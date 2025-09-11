defmodule Ceres.Storage.Converter do
alias Ceres.Titles
alias Ceres.Storage.S3

  require Logger
  @doc """
  Convert dir of images to avif files.

  Sends messages to parent process:
  {:started, files}
  {:converted, {ref, size}}
  {:error, error}
  """
  def dir_to_avif(path, parent_pid, chapter_id) do
    case File.ls(path) do
      {:ok, files} ->
        files = files_stat(path, files)
        send(parent_pid, {:started, files})
        convert_files(path, files, parent_pid, chapter_id)
      {:error, error} ->
        Logger.error("Error while listing files in #{path}. Error: #{inspect(error)}")
        send(parent_pid, {:error, error})
    end
  end

  defp convert_files(_basepath, [], parent_pid, chapter_id), do: nil

  defp convert_files(basepath, [{ref, path, size} | tail], parent_pid, chapter_id) do
    case File.regular?(path) do
      true ->
        new_path = "#{basepath}/#{Path.basename(Path.rootname(path))}.avif"
        case System.cmd("ffmpeg", ["-i", "#{path}", "-c:v", "libaom-av1", "-still-picture", "1", "-crf", "20", "-b:v", "0", "-hide_banner", "-loglevel", "error", new_path]) do
          {_output, 0} ->
            send(parent_pid, {:converted, {ref, File.stat!(new_path).size}})

            chapter = Titles.get_chapter!(chapter_id)

            name = "#{chapter.comic_id}/#{chapter.id}/#{Path.basename(Path.rootname(path))}.avif"

            page = Titles.create_page(%{
              chapter_id: chapter_id,
              number: String.to_integer(Path.basename(Path.rootname(path))),
              source: "comics:#{name}"
              })

            Task.start(fn -> S3.upload_image_to_s3(new_path, parent_pid, name, ref) end)

            File.rm!(path)
            convert_files(basepath, tail, parent_pid, chapter_id)
          {output, _} ->
            send(parent_pid, {:error, "Error while converting #{path}. Output: #{output}"})
            Logger.error("Error while converting #{path}. Output: #{output}")
            File.rm_rf!(basepath)
        end
      false ->
        Logger.error("File is not regular, #{path}. Stopped converting.")
        send(parent_pid, {:error, "File #{path} is not regular, stopped"})
        File.rm_rf!(basepath)
    end
  end

  defp files_stat(base, files) do
    stats = Enum.map(files, fn file ->
      path = Path.join(base, file)
      stat = File.stat!(path)
      {make_ref(), path, stat.size}
    end)
  end
end

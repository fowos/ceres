defmodule Ceres.Storage.Converter do
alias Ceres.Titles
alias Ceres.Storage.S3

  require Logger

  @spec get_files(String.t()) :: [{reference(), String.t(), integer(), integer()}]
  def get_files(dirpath) do
    File.ls!(dirpath)
    |> Enum.map(fn file ->
      path = Path.join(dirpath, file)
      if not File.regular?(path), do: raise "File #{path} is not regular"
      {index, _other} = Integer.parse(Path.basename(file))
      {make_ref(), path, File.stat!(path).size, index}
    end)
  end


  @doc """
  Convert dir of images to avif files

  Can send messages to view process

  {:converted, {ref, size}}

  ## Examples

      iex> convert_files_to_avif(files, self())
      [{:ok, ref, index, path} | {:error, ref, index, error}]
  """

  @spec convert_files_to_avif([{reference(), String.t(), integer()}], pid())
    :: [{:ok, reference(), integer(), String.t()} | {:error, reference(), integer(), String.t()}]

  def convert_files_to_avif(files, view_pid) do
    files
    |> Flow.from_enumerable()
    |> Flow.partition(stages: 12)
    |> Flow.map(&format_file(&1))
    |> Flow.map(&image_to_avif(&1, view_pid))
    |> Flow.reduce(fn -> [] end, fn res, acc -> [res | acc] end)
    |> Enum.sort_by(fn {_status, _ref, index, _} -> index end)
  end


  defp format_file({ref, file, _size, index}) do
    dest = Path.join(Path.dirname(file), "#{generate_id()}.avif")
    {:file, ref, index, file, dest}
  end


  @spec image_to_avif({:file, reference(), integer(), String.t(), String.t()}, pid())
    :: {:ok, reference(), integer(), String.t()} | {:error, reference(), integer(), String.t()}

  defp image_to_avif({:file, ref, index, from, dest}, view_pid) do
    case System.cmd("ffmpeg", ["-i", from, "-c:v", "libaom-av1", "-still-picture", "1", "-crf", "20", "-b:v", "0", "-hide_banner", "-loglevel", "error", dest]) do
      {_output, 0} ->
        send(view_pid, {:converted, {ref, File.stat!(dest).size}})
        {:ok, ref, index, dest}
      {output, _} ->
        Logger.error("Error while converting #{from}. Output: #{output}")
        send(view_pid, {:error, "Error while converting #{from}. Please check server logs."})
        {:error, ref, index, output}
    end
  end


  defp generate_id(length \\ 16) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
    |> String.replace(~r/[-_]/, "")
    |> String.slice(0, length)
  end
end

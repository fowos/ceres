defmodule CeresWeb.Comics.Components.Cover do

  alias Ceres.Repo
  alias Ceres.Titles
  alias Ceres.Storage.S3
  alias Ceres.Storage.Converter
  use CeresWeb, :live_component

  require Logger


  @impl Phoenix.LiveComponent
  def mount(socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveComponent
  def update(assigns, socket) do

    socket = socket
    |> allow_upload(:cover, accept: ~w(.jpg .jpeg .png), max_entries: 1, max_file_size: 20_000_000)
    |> assign(:comic, assigns.comic |> Repo.preload(:cover))

    {:ok, socket}
  end



  @impl Phoenix.LiveComponent
  def handle_event("validate-cover", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveComponent
  def handle_event("submit-cover", params, socket) do
    IO.inspect(params, label: "params")

    consume_uploaded_entries(socket, :cover, fn %{path: path}, entry ->
      dest = upload_tmpdir()
      File.mkdir_p!(dest)

      IO.inspect(dest, label: "dest") # TODO

      destpath = Path.join(dest, entry.client_name)

      File.cp!(path, destpath)

      save_cover(destpath, socket.assigns.comic.id)
      {:ok, destpath}
    end)


    {:noreply, socket}
  end

  defp save_cover(filepath, comic_id) do
    Task.start(fn ->
      basedir = Path.dirname(filepath)

      converted = Converter.get_files(basedir)
      |> Converter.convert_files_to_avif(nil)

      if Enum.any?(converted, fn {status, _ref, _index, _path} -> status == :error end) do
        Logger.error("Error while converting images. Directory #{basedir} will be removed.")
        File.rm_rf!(basedir)
      end

      converted
      |> List.first()
      |> save_cover_to_s3("comics", comic_id)

      case converted do
        {:error, error} ->
          Logger.error("Error while saving cover. Error: #{inspect(error)}")
        _ ->
          :ok
      end
    end)
  end

  defp save_cover_to_s3({:ok, ref, index, file}, bucket, comic_id) do
    s3_dest = "#{comic_id}/cover.avif"

    case Titles.get_cover_by_comic_id(comic_id) do
      nil ->
        :ok
      cover ->
        S3.remove_from_s3(bucket, cover.source)
        Titles.delete_cover(cover)
    end

    case Titles.create_cover(%{source: "#{bucket}:#{s3_dest}", comic_id: comic_id}) do
      {:ok, cover} ->
        case S3.upload_to_s3(bucket, file, s3_dest) do
          {:ok, source} ->
            {:ok, source}
          {:error, error} ->
            Logger.error("Error while uploading #{file} to s3. Error: #{inspect(error)}")
            {:error, error}
        end
      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error("Error while saving cover #{inspect(changeset)}")
        {:error, changeset}
    end

    File.rm_rf!(Path.dirname(file))
  end

  @doc """
    Generate path to basedir for uploaded images
  """
  defp upload_tmpdir, do: "#{System.tmp_dir!}/#{generate_id()}"
  defp generate_id(length \\ 24) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
    |> String.replace(~r/[-_]/, "")
    |> String.slice(0, length)
  end

  def parse_image_source(source), do: "/api/image/" <> source

end

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

    cover? = assigns.comic |> Repo.preload(:cover) |> Map.get(:cover)

    socket = socket
    |> allow_upload(:cover, accept: ~w(.jpg .jpeg .png), max_entries: 1, max_file_size: 20_000_000)
    |> assign(:comic, assigns.comic)
    |> assign(:cover, cover?)

    {:ok, socket}
  end



  @impl Phoenix.LiveComponent
  def handle_event("validate-cover", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveComponent
  def handle_event("submit-cover", params, socket) do
    IO.inspect(params, label: "params")

    filepath = consume_uploaded_entries(socket, :cover, fn %{path: path}, entry ->
      dest = Converter.generate_tmpdir()
      File.mkdir_p!(dest)

      filepath = Path.join(dest, entry.client_name)
      File.cp!(path, filepath)
      {:ok, filepath}
    end)


    case save_cover(filepath, socket.assigns.comic.id) do
      :ok ->
        socket = socket
        |> put_flash(:info, "Cover uploaded successfully")
        |> assign(:cover, Titles.get_cover_by_comic_id(socket.assigns.comic.id))

        {:noreply, socket}
      {:error, error} ->
        Logger.error("Error while uploading cover. #{inspect(error)}")
        socket = socket
        |> put_flash(:error, "Error while uploading cover. #{inspect(error)}")
        {:noreply, socket}
    end
  end

  defp save_cover(filepath, comic_id) do
    case Titles.get_cover_by_comic_id(comic_id) do
      %Titles.Cover{} = cover -> Titles.delete_cover(cover)
      _ -> nil
    end

    case Titles.create_cover(%{source: "comics:#{comic_id}/cover.jpeg", comic_id: comic_id}) do
      {:ok, cover} ->
        case S3.upload_to_s3("comics", filepath, "#{comic_id}/cover.jpeg") do
          {:ok, _path} -> :ok
          {:error, error} -> {:error, error}
        end
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Parse cover source

  DateTime.utc_now() used for force refresh image in browser
  """
  def parse_image_source(cover) do
    IO.inspect(cover, label: "cover")

    "/api/image/" <> cover.source <> "?date=#{DateTime.utc_now()}"
  end
end

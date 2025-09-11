defmodule CeresWeb.Chapters.ChaptersNew do
  use CeresWeb, :live_view

  alias Ceres.Titles.Chapter
  alias Ceres.Titles

  require Logger

  @impl Phoenix.LiveView
  def mount(%{"id" => id}, _session, socket) do
    comic = Titles.get_comic!(id)

    socket = socket
    |> assign(:comic, comic)
    |> assign(:chapter, %Chapter{comic_id: comic.id})
    |> assign(:form, Titles.change_chapter(%Chapter{}) |> to_form)
    |> assign(:status, nil)
    |> assign(:pages, [])
    |> allow_upload(:chapter_zip, accept: ~w(.zip), max_entries: 1, max_file_size: 50_000_000)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"chapter" => chapter_params}, socket) do
    IO.inspect(chapter_params, label: "chapter params")

    changeset =
      Titles.change_chapter(socket.assigns.chapter, chapter_params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(:form, to_form(changeset))}
  end

  @impl Phoenix.LiveView
  def handle_event("save", %{"chapter" => chapter_params}, socket) do
    chapter = %{
      comic_id: socket.assigns.comic.id,
      volume: String.to_integer(chapter_params["volume"]),
      number: String.to_integer(chapter_params["number"])
    }

    with {:ok, %Chapter{} = chapter} <- Titles.create_chapter(chapter) |> IO.inspect(label: "chapter"),
    {:ok, _path} <- parse_zip_chapter(
        socket,
        socket.assigns.uploads.chapter_zip,
        socket.assigns.comic.id,
        chapter_params["volume"],
        chapter_params["number"],
        chapter.id
      )
      do

        {:noreply, socket |> assign(:created_chapter_id, chapter.id)}
      else
        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, socket |> assign(:form, to_form(changeset))}
        other ->
          {:noreply, socket |> put_flash(:error, "Error while creating chapter. #{inspect(other)}")}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("validate-upload", _params, socket) do
    {:noreply, socket}
  end

  defp parse_zip_chapter(socket, chapter_zip, comic_id, volume, number, chapter_id) do
    uploaded_files =
      consume_uploaded_entries(socket, :chapter_zip, fn %{path: path} = params, _entry ->
        with {:ok, binary} <- File.read(path),
          {:ok, files} <- :zip.unzip(binary, [{:cwd, ~c"#{get_path_to_uploads(comic_id, volume, number)}"}])
          do
            pid = self()
            Task.start(fn -> Ceres.Storage.Converter.dir_to_avif(get_path_to_uploads(comic_id, volume, number), pid, chapter_id) end)
            {:ok, "priv/static/uploads/#{comic_id}"}
          else
            other ->
              IO.inspect(other, label: "other")
              Logger.error("Error while unzipping chapter. \n #{inspect(other)}")
              {:error, "Error while unzipping chapter"}
          end
      end)
    {:ok, uploaded_files}
  end

  defp get_path_to_uploads(comic_id, volume, number), do: "priv/static/uploads/#{comic_id}/#{volume}-#{number}"


  def handle_info({:started, files}, socket) do
    pages = Enum.map(files, fn {ref, path, size} ->
      %{id: :erlang.ref_to_list(ref), path: path, size: size, new_size: nil, is_converted: false, s3: false}
    end)
    |> IO.inspect(label: "pages")

    socket = socket
    |> assign(:status, :started)
    |> assign(:pages, pages)


    {:noreply, socket}
  end

  def handle_info({:error, error}, socket) do
    Titles.get_chapter!(socket.assigns.created_chapter_id)
    |> Titles.delete_chapter()

    {:noreply, socket |> put_flash(:error, "Error while creating chapter. #{inspect(error)}")}
  end

  @doc """
  Handle info from convert_to_avif
  """
  def handle_info({:converted, {ref, size}}, socket) do
    pages = socket.assigns.pages
    page = Enum.find(pages, fn p -> p.id == :erlang.ref_to_list(ref) end)

    socket = socket
    |> assign(:pages, List.replace_at(pages, pages |> Enum.find_index(fn p -> p.id == :erlang.ref_to_list(ref) end), %{page | new_size: size, is_converted: true}))

    {:noreply, socket}
  end

  def handle_info({:saved, ref}, socket) do
    pages = socket.assigns.pages

    page = Enum.find(pages, fn p -> p.id == :erlang.ref_to_list(ref) end)

    socket = socket
    |> assign(:pages, List.replace_at(pages, pages |> Enum.find_index(fn p -> p.id == :erlang.ref_to_list(ref) end), %{page | s3: true}))

    {:noreply, socket}
  end
end

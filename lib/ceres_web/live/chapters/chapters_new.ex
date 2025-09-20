defmodule CeresWeb.Chapters.ChaptersNew do
  use CeresWeb, :live_view

  alias Ceres.Titles.Chapter
  alias Ceres.Titles
  alias Ceres.Titles.Page
  alias Ceres.Storage.S3
  alias Ceres.Storage.Converter

  require Logger

  @bucket "comics"

  @impl Phoenix.LiveView
  def mount(%{"id" => id}, _session, socket) do
    comic = Titles.get_comic!(id)

    socket = socket
    |> assign(:comic, comic)
    |> assign(:chapter, %Chapter{comic_id: comic.id})
    |> assign(:form, Titles.change_chapter(%Chapter{}) |> to_form)
    |> assign(:status, nil)
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
        {:ok, tmpdir} <- parse_zip_chapter(socket, chapter)
      do
        # convert_images(tmpdir, chapter.id)  # TODO

        {:noreply, socket |> assign(:created_chapter_id, chapter.id)}
      else
        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, socket |> assign(:form, to_form(changeset))}
        other ->
          {:noreply, socket |> put_flash(:error, "Error while creating chapter. #{inspect(other)}")}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("validate-upload", _params, socket), do: {:noreply, socket}

  defp parse_zip_chapter(socket, %Chapter{} = chapter) do
    path = consume_uploaded_entries(socket, :chapter_zip, fn %{path: path}, _entry ->
      tmpdir = Converter.generate_tmpdir()

      with {:ok, binary} <- File.read(path),
           {:ok, _files} <- :zip.unzip(binary, [{:cwd, String.to_charlist(tmpdir)}])
      do
        mypid = self()

        Task.start(fn ->
          res = save_pages(tmpdir, chapter.id)
          if Enum.any?(res, &match?({:error, _}, &1)) do
            send(mypid, {:status, {:error, "Error while saving pages, please check server logs."}})
          else
            send(mypid, {:status, :ok})
          end
        end)

        {:ok, tmpdir}
      else
        other ->
          raise "Error while unzipping chapter. \n#{inspect(other)}"
      end
    end)

    if Enum.count(path) == 1 do
      {:ok, List.first(path)}
    else
      {:ok, path}
    end
  end

  defp save_pages(tmpdir, chapter_id) do
    Converter.files(tmpdir)
    |> Enum.map(fn {index, filepath} ->
      page_params = %{chapter_id: chapter_id, number: index, source: "#{@bucket}:#{chapter_id}/#{index}.jpeg"}

      case Titles.create_page(page_params) do
        {:ok, %Page{} = page} ->
          case S3.upload_to_s3(@bucket, filepath, "#{chapter_id}/#{index}.jpeg") do
            {:ok, _path} ->
              :ok

            {:error, error} ->
              Logger.error("Error while uploading #{filepath} to s3. Error: #{inspect(error)}")
              {:error, error}
          end

        {:error, changeset} ->
          Logger.error("Error while creating page.\n#{inspect(changeset)}")
          {:error, changeset}
      end
    end)
  end

  def handle_info({:status, msg}, socket) do
    socket = case msg do
      :ok ->
        socket |> assign(:status, :ok)
      {:error, msg} ->
        socket  |> assign(:status, :error) |> put_flash(:error, msg)
    end
    {:noreply, socket}
  end

  @spec parse_status(:ok | :error) :: String.t()
  def parse_status(status) do
    case status do
      :ok -> "Succesfully uploaded"
      :error -> "Error while uploading"
    end
  end
end

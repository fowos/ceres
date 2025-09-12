defmodule CeresWeb.Chapters.ChaptersHome do
  alias Ceres.Storage.S3
  alias Ceres.Repo
  alias Ceres.Titles
  use CeresWeb, :live_view


  require Logger


  @impl Phoenix.LiveView
  def mount(%{"id" => id}, _session, socket) do
    socket = socket
    |> stream(:chapters, Titles.get_comics_chapters(id) |> Repo.preload(:pages))
    |> assign(:comic, Titles.get_comic!(id))

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("delete-chapter", %{"id" => id}, socket) do
    chapter = Titles.get_chapter!(id) |> Repo.preload(:pages)
    Titles.delete_chapter(chapter)

    for page <- chapter.pages do
      case S3.remove_image_from_s3(page.source) do
        :ok ->
          Titles.delete_page(page)
        {:error, error} -> Logger.error("Error while deleting chapter: #{inspect(error)}")
      end
    end

    socket = socket
    |> stream_delete(:chapters, chapter)

    {:noreply, socket}
  end
end

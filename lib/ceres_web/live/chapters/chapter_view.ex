defmodule CeresWeb.Chapters.ChapterView do
  alias Ceres.Repo
  alias Ceres.Titles
  use CeresWeb, :live_view

  alias Titles
  alias Titles.Chapter

  @impl Phoenix.LiveView
  def mount(%{"id" => id}, _session, socket) do
    pages = Titles.list_pages_by_chapter_id(id)
    chapter = Titles.get_chapter!(id)
    comic = Titles.get_comic!(chapter.comic_id)

    socket = socket
    |> assign(:chapter, chapter)
    |> assign(:comic, comic)
    |> assign(:pages, pages)

    {:ok, socket}
  end

  def parse_image_source(source), do: "/api/image/" <> source
end

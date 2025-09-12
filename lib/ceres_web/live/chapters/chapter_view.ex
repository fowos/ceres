defmodule CeresWeb.Chapters.ChapterView do
  alias Ceres.Repo
  alias Ceres.Titles
  use CeresWeb, :live_view

  alias Titles
  alias Titles.Chapter

  @impl Phoenix.LiveView
  def mount(%{"id" => id}, _session, socket) do
    chapter = Titles.get_chapter!(id) |> Repo.preload(:pages)

    socket = socket
    |> assign(:chapter, chapter)

    {:ok, socket}
  end


  def parse_image_source("comics:" <> source), do: "/api/image/" <> source
  def parse_image_source(source), do: raise "Invalid image source: #{source}"
end

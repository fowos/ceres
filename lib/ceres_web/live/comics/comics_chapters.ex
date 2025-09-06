defmodule CeresWeb.Comics.ComicsChapters do
alias Ceres.Titles
  use CeresWeb, :live_view


  require Logger


  @impl true
  def mount(%{"id" => id}, _session, socket) do
    socket = socket
    |> stream(:chapters, Titles.get_comics_chapters(id))
    |> assign(:comic, Titles.get_comic!(id))

    {:ok, socket}
  end
end

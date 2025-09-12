defmodule CeresWeb.Api.Pages.PagesController do
  alias Ceres.Repo
  alias Ceres.Titles
  use CeresWeb, :controller

  action_fallback CeresWeb.Api.FallbackController

  @doc """
  All pages by comic ID
  """
  def index(conn, %{"id" => id}) do
    pages = Titles.list_pages_by_chapter_id(id)

    render(conn, :index, pages: pages)
  end
end

defmodule CeresWeb.Api.Tags.TagsController do
  alias Ceres.Tags
  use CeresWeb, :controller

  @doc """
  List all tags
  """
  @impl Phoenix.Controller
  def index(conn, _params) do
    tags = Tags.list_tags()
    render(conn, :index, tags: tags)
  end
end

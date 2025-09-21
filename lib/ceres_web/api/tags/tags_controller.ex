defmodule CeresWeb.Api.Tags.TagsController do
  alias Ceres.Tags
  use CeresWeb, :controller

  @doc """
  List all tags
  """
  @impl Phoenix.Controller
  def index(conn, params) do
    limit = Map.get(params, "limit", "1000") |> String.to_integer()
    offset = Map.get(params, "offset", "0") |> String.to_integer()

    tags = Tags.list_tags(limit: limit, offset: offset)
    render(conn, :index, tags: tags)
  end

  @impl Phoenix.Controller
  def create(conn, %{"name" => name}) do
    case Tags.get_tag_by_name(name) do
      nil ->
        case Tags.create_tag(%{name: name}) do
          {:ok, tag} ->
            render(conn, :show, tag: tag)
          {:error, %Ecto.Changeset{} = changeset} ->
            Logger.error("Error while creating tag entity.\n#{inspect(changeset)}")
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Error while creating tag entity. Check server logs, please."})
        end
      tag ->
        render(conn, :show, tag: tag)
    end
  end
end

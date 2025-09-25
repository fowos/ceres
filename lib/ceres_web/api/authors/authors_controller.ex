defmodule CeresWeb.Api.Authors.AuthorsController do
alias Ceres.Authors


  require Logger

  use CeresWeb, :controller

  action_fallback CeresWeb.Api.FallbackController

  def index(conn, params) do
    offset = Map.get(params, "offset", "0") |> String.to_integer()
    limit = Map.get(params, "limit", "100") |> String.to_integer()

    authors = Authors.list_authors(offset: offset, limit: limit)
    render(conn, :index, authors: authors)
  end

  def create(conn, %{"name" => name, "description" => description}) do
    case Authors.get_author_by_name(name) do
      nil ->
        case Authors.create_author(%{name: name, description: description}) do
          {:ok, author} ->
            render(conn, :show, author: author)
          {:error, %Ecto.Changeset{} = changeset} ->
            Logger.error("Error while creating author entity.\n#{inspect(changeset)}")
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Error while creating author entity. Check server logs, please."})
        end
      author ->
        render(conn, :show, author: author)
    end
  end
end

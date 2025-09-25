defmodule CeresWeb.Api.Publishers.PublishersController do
  alias Ceres.Authors

  require Logger

  use CeresWeb, :controller

  action_fallback CeresWeb.Api.FallbackController

  def index(conn, params) do
    offset = Map.get(params, "offset", "0") |> String.to_integer()
    limit = Map.get(params, "limit", "100") |> String.to_integer()

    publishers = Authors.list_publishers(offset: offset, limit: limit)
    render(conn, :index, publishers: publishers)
  end

  def create(conn, %{"name" => name, "description" => description}) do
    case Authors.get_publisher_by_name(name) do
      nil ->
        case Authors.create_publisher(%{name: name, description: description}) do
          {:ok, publisher} ->
            render(conn, :show, publisher: publisher)
          {:error, %Ecto.Changeset{} = changeset} ->
            Logger.error("Error while creating publisher entity.\n#{inspect(changeset)}")
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Error while creating publisher entity. Check server logs, please."})
        end
      publisher ->
        render(conn, :show, publisher: publisher)
    end
  end
end

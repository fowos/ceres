defmodule CeresWeb.Api.Localizers.LocalizersController do
  alias Ceres.Localizers

  import Ecto.Changeset

  require Logger

  use CeresWeb, :controller

  action_fallback CeresWeb.Api.FallbackController

  def index(conn, params) do
    offset = Map.get(params, "offset", "0") |> String.to_integer()
    limit = Map.get(params, "limit", "100") |> String.to_integer()

    localizers = Localizers.list_localizers(offset: offset, limit: limit)
    render(conn, :index, localizers: localizers)
  end

  def create(conn, %{"name" => name, "description" => description}) do
    case Localizers.get_localizer_by_name(name) do
      nil ->
        case Localizers.create_localizer(%{name: name, description: description}) do
          {:ok, localizer} ->
            render(conn, :show, localizer: localizer)
          {:error, %Ecto.Changeset{} = changeset} ->
            Logger.error("Error while creating localizer entity.\n#{inspect(changeset)}")
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Error while creating localizer entity. Check server logs, please."})
        end
      localizer ->
        render(conn, :show, localizer: localizer)
    end
  end
end

defmodule CeresWeb.Api.Titles.TitlesController do
  alias Ceres.Titles.Title
  alias Ceres.Repo
  alias Ceres.Titles
  alias Ecto

  require Logger

  import Ecto.Query

  use CeresWeb, :controller

  action_fallback CeresWeb.Api.FallbackController


  def show(conn, %{"name" => name}) do
    case Titles.get_title_by_name(name) do
      %Title{} = title ->
        render(conn, "show.json", title: title)
      other ->
        Logger.error("Error while getting title. Error: #{inspect(other)}")
        conn
        |> put_status(:not_found)
        |> text("Title not found")
    end
  end

  def create(conn, %{"name" => name, "type" => type}) do
    case Titles.create_title(%{name: name, type: type}) do
      {:ok, title} ->
        render(conn, "show.json", title: title)
      other ->
        Logger.error("Error while creating title. Error: #{inspect(other)}")
        conn
        |> put_status(:bad_request)
        |> text("Error while creating title")
    end
  end
end

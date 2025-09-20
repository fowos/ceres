defmodule CeresWeb.Api.Chapters.ChaptersController do
  alias Ceres.Titles.Title
  alias Ceres.Repo
  alias Ceres.Titles
  alias Ecto


  import Ecto.Query

  use CeresWeb, :controller

  action_fallback CeresWeb.Api.FallbackController


  def upload(conn, %{
    "file" => %Plug.Upload{} = upload,
    "chapter" => chapter
  }) do

    raise "Not implemented"
  end
end

defmodule CeresWeb.Api.Comics.ComicsController do
  alias Ceres.Repo
  alias Ceres.Titles
  use CeresWeb, :controller

  action_fallback CeresWeb.Api.FallbackController

  @doc """
  Finc comics by part name
  """
  def index(conn, %{"name" => name}) do
    comics = Titles.get_comics_list_by_part_name(name, [:localizers, :chapters])

    titles_comics = Titles.get_titles_list_by_part_name(name, [comics: [:localizers, :chapters]])
    |> Enum.map(fn title -> title.comics end)
    |> Enum.reduce(comics, fn comics, acc -> comics ++ acc end)

    comics = comics
    |> Enum.reduce(titles_comics, fn comic, acc -> [comic | acc] end)
    |> Enum.uniq()

    render(conn, :index, comics: comics)
  end

  @doc """
  List all comics
  """
  def index(conn, _params) do
    comics = Titles.list_comics() |> Repo.preload([:localizers, :chapters])
    render(conn, :index, comics: comics)
  end
end

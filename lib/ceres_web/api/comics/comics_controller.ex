defmodule CeresWeb.Api.Comics.ComicsController do
  require Logger
  alias Ceres.Localizers
  alias Ceres.Titles.Title
  alias Ceres.Repo
  alias Ceres.Titles
  alias Ecto


  import Ecto.Query

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


    comics = Repo.preload(comics, [:cover, :localizers, :chapters, title: [:authors, :publishers, :tags]])

    render(conn, :index, comics: comics)
  end


  def index(conn, params) do
    comics = Titles.list_comics()
    |> Repo.preload([:localizers, :chapters, :cover, title: [:authors, :publishers, :tags]])
    render(conn, :index, comics: comics)
  end

  def by_params(conn, params) do
    comics = Title
    |> search_by_tags(params["tags"])
    |> search_by_publishers(params["publishers"])
    |> search_by_authors(params["authors"])
    |> Repo.all()
    |> Repo.preload([comics: [:localizers, :chapters, :cover, title: [:authors, :publishers, :tags]]])
    |> Enum.map(fn title -> title.comics end)
    |> Enum.reduce([], fn comics, acc -> comics ++ acc end)
    |> Enum.uniq()

    render(conn, :index, comics: comics)
  end



  defp search_by_tags(query, nil), do: query
  defp search_by_tags(query, tags) when is_list(tags) do
    query
    |> join(:inner, [t], tag in assoc(t, :tags), as: :tag)
    |> where([tag: tag], tag.name in ^tags)
  end

  defp search_by_publishers(query, nil), do: query
  defp search_by_publishers(query, publishers) when is_list(publishers) do
    query
    |> join(:inner, [t], publisher in assoc(t, :publishers), as: :publisher)
    |> where([publisher: publisher], publisher.name in ^publishers)
  end

  defp search_by_authors(query, nil), do: query
  defp search_by_authors(query, authors) when is_list(authors) do
    authors_count = length(authors)

    query
    # связываем Title → AuthorsTitles
    |> join(:inner, [t], at in assoc(t, :authors_titles), as: :authors_titles)
    # связываем AuthorsTitles → Author
    |> join(:inner, [authors_titles: at], a in assoc(at, :author), as: :author)
    |> group_by([t], t.id)
    |> having(
        [t, authors_titles: _at, author: a],
        sum(fragment("CASE WHEN ? = ANY(?) THEN 1 ELSE 0 END", a.name, ^authors)) == ^length(authors)
      )
  end


  def create(conn, %{
    "title_id" => title_id,
    "name" => name,
    "description" => description,
    "language" => language,
    "localizers_id" => localizers_id_list
    }) do

    attrs = %{
      title_id: title_id,
      name: name,
      description: description,
      language: language
    }

    case Titles.create_comic(attrs) do
      {:ok, comic} ->
        localizers_id_list
        |> Enum.map(fn localizer_id ->
          Localizers.create_localizers_comics(%{localizer_id: localizer_id, comic_id: comic.id})
        end)

        comic = Repo.preload(comic, [:cover, :localizers, :chapters, title: [:authors, :publishers, :tags]])
        render(conn, :show, comic: comic)

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error("Error while creating comic entity.\n#{inspect(changeset)}")
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Error while creating comic entity. Check server logs, please."})
    end

  end
end

defmodule Ceres.Titles do
  @moduledoc """
  The Titles context.
  """

  import Ecto.Query, warn: false
  alias Ceres.Repo

  alias Ceres.Titles.Title
  alias Ceres.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any title changes.

  The broadcasted messages match the pattern:

    * {:created, %Title{}}
    * {:updated, %Title{}}
    * {:deleted, %Title{}}

  """
  def subscribe_titles(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Ceres.PubSub, "user:#{key}:titles")
  end

  defp broadcast_title(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Ceres.PubSub, "user:#{key}:titles", message)
  end

  @doc """
  Returns the list of titles.

  ## Examples

      iex> list_titles(scope)
      [%Title{}, ...]

  """
  def list_titles(%Scope{} = scope) do
    Repo.all_by(Title, user_id: scope.user.id)
  end

  @doc """
  Gets a single title.

  Raises `Ecto.NoResultsError` if the Title does not exist.

  ## Examples

      iex> get_title!(scope, 123)
      %Title{}

      iex> get_title!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_title!(%Scope{} = scope, id) do
    Repo.get_by!(Title, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a title.

  ## Examples

      iex> create_title(scope, %{field: value})
      {:ok, %Title{}}

      iex> create_title(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_title(%Scope{} = scope, attrs) do
    with {:ok, title = %Title{}} <-
           %Title{}
           |> Title.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_title(scope, {:created, title})
      {:ok, title}
    end
  end

  @doc """
  Updates a title.

  ## Examples

      iex> update_title(scope, title, %{field: new_value})
      {:ok, %Title{}}

      iex> update_title(scope, title, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_title(%Scope{} = scope, %Title{} = title, attrs) do
    true = title.user_id == scope.user.id

    with {:ok, title = %Title{}} <-
           title
           |> Title.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_title(scope, {:updated, title})
      {:ok, title}
    end
  end

  @doc """
  Deletes a title.

  ## Examples

      iex> delete_title(scope, title)
      {:ok, %Title{}}

      iex> delete_title(scope, title)
      {:error, %Ecto.Changeset{}}

  """
  def delete_title(%Scope{} = scope, %Title{} = title) do
    true = title.user_id == scope.user.id

    with {:ok, title = %Title{}} <-
           Repo.delete(title) do
      broadcast_title(scope, {:deleted, title})
      {:ok, title}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking title changes.

  ## Examples

      iex> change_title(scope, title)
      %Ecto.Changeset{data: %Title{}}

  """
  def change_title(%Scope{} = scope, %Title{} = title, attrs \\ %{}) do
    true = title.user_id == scope.user.id

    Title.changeset(title, attrs, scope)
  end

  alias Ceres.Titles.Comic

  @doc """
  Returns the list of comics.

  ## Examples

      iex> list_comics()
      [%Comic{}, ...]

  """
  def list_comics do
    Repo.all(Comic)
  end

  @doc """
  Gets a single comic.

  Raises `Ecto.NoResultsError` if the Comic does not exist.

  ## Examples

      iex> get_comic!(123)
      %Comic{}

      iex> get_comic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comic!(id), do: Repo.get!(Comic, id)

  @doc """
  Creates a comic.

  ## Examples

      iex> create_comic(%{field: value})
      {:ok, %Comic{}}

      iex> create_comic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comic(attrs) do
    %Comic{}
    |> Comic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comic.

  ## Examples

      iex> update_comic(comic, %{field: new_value})
      {:ok, %Comic{}}

      iex> update_comic(comic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comic(%Comic{} = comic, attrs) do
    comic
    |> Comic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comic.

  ## Examples

      iex> delete_comic(comic)
      {:ok, %Comic{}}

      iex> delete_comic(comic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comic(%Comic{} = comic) do
    Repo.delete(comic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comic changes.

  ## Examples

      iex> change_comic(comic)
      %Ecto.Changeset{data: %Comic{}}

  """
  def change_comic(%Comic{} = comic, attrs \\ %{}) do
    Comic.changeset(comic, attrs)
  end

  alias Ceres.Titles.Chapter

  @doc """
  Returns the list of chapters.

  ## Examples

      iex> list_chapters()
      [%Chapter{}, ...]

  """
  def list_chapters do
    Repo.all(Chapter)
  end

  @doc """
  Gets a single chapter.

  Raises `Ecto.NoResultsError` if the Chapter does not exist.

  ## Examples

      iex> get_chapter!(123)
      %Chapter{}

      iex> get_chapter!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chapter!(id), do: Repo.get!(Chapter, id)

  @doc """
  Creates a chapter.

  ## Examples

      iex> create_chapter(%{field: value})
      {:ok, %Chapter{}}

      iex> create_chapter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chapter(attrs) do
    %Chapter{}
    |> Chapter.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chapter.

  ## Examples

      iex> update_chapter(chapter, %{field: new_value})
      {:ok, %Chapter{}}

      iex> update_chapter(chapter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chapter(%Chapter{} = chapter, attrs) do
    chapter
    |> Chapter.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a chapter.

  ## Examples

      iex> delete_chapter(chapter)
      {:ok, %Chapter{}}

      iex> delete_chapter(chapter)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chapter(%Chapter{} = chapter) do
    Repo.delete(chapter)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chapter changes.

  ## Examples

      iex> change_chapter(chapter)
      %Ecto.Changeset{data: %Chapter{}}

  """
  def change_chapter(%Chapter{} = chapter, attrs \\ %{}) do
    Chapter.changeset(chapter, attrs)
  end

  alias Ceres.Titles.Page

  @doc """
  Returns the list of pages.

  ## Examples

      iex> list_pages()
      [%Page{}, ...]

  """
  def list_pages do
    Repo.all(Page)
  end

  @doc """
  Gets a single page.

  Raises `Ecto.NoResultsError` if the Page does not exist.

  ## Examples

      iex> get_page!(123)
      %Page{}

      iex> get_page!(456)
      ** (Ecto.NoResultsError)

  """
  def get_page!(id), do: Repo.get!(Page, id)

  @doc """
  Creates a page.

  ## Examples

      iex> create_page(%{field: value})
      {:ok, %Page{}}

      iex> create_page(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_page(attrs) do
    %Page{}
    |> Page.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a page.

  ## Examples

      iex> update_page(page, %{field: new_value})
      {:ok, %Page{}}

      iex> update_page(page, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_page(%Page{} = page, attrs) do
    page
    |> Page.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a page.

  ## Examples

      iex> delete_page(page)
      {:ok, %Page{}}

      iex> delete_page(page)
      {:error, %Ecto.Changeset{}}

  """
  def delete_page(%Page{} = page) do
    Repo.delete(page)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking page changes.

  ## Examples

      iex> change_page(page)
      %Ecto.Changeset{data: %Page{}}

  """
  def change_page(%Page{} = page, attrs \\ %{}) do
    Page.changeset(page, attrs)
  end
end

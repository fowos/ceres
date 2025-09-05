defmodule Ceres.Authors do
  @moduledoc """
  The Authors context.
  """

  import Ecto.Query, warn: false
  alias Ceres.Repo

  alias Ceres.Authors.Author

  @doc """
  Returns the list of authors.

  ## Examples

      iex> list_authors()
      [%Author{}, ...]

  """
  def list_authors do
    Repo.all(Author)
  end

  @doc """
  Gets a single author.

  Raises `Ecto.NoResultsError` if the Author does not exist.

  ## Examples

      iex> get_author!(123)
      %Author{}

      iex> get_author!(456)
      ** (Ecto.NoResultsError)

  """
  def get_author!(id), do: Repo.get!(Author, id)

  @doc """
  Creates a author.

  ## Examples

      iex> create_author(%{field: value})
      {:ok, %Author{}}

      iex> create_author(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_author(attrs) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a author.

  ## Examples

      iex> update_author(author, %{field: new_value})
      {:ok, %Author{}}

      iex> update_author(author, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a author.

  ## Examples

      iex> delete_author(author)
      {:ok, %Author{}}

      iex> delete_author(author)
      {:error, %Ecto.Changeset{}}

  """
  def delete_author(%Author{} = author) do
    Repo.delete(author)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking author changes.

  ## Examples

      iex> change_author(author)
      %Ecto.Changeset{data: %Author{}}

  """
  def change_author(%Author{} = author, attrs \\ %{}) do
    Author.changeset(author, attrs)
  end

  alias Ceres.Authors.Publisher

  @doc """
  Returns the list of publishers.

  ## Examples

      iex> list_publishers()
      [%Publisher{}, ...]

  """
  def list_publishers do
    Repo.all(Publisher)
  end

  @doc """
  Gets a single publisher.

  Raises `Ecto.NoResultsError` if the Publisher does not exist.

  ## Examples

      iex> get_publisher!(123)
      %Publisher{}

      iex> get_publisher!(456)
      ** (Ecto.NoResultsError)

  """
  def get_publisher!(id), do: Repo.get!(Publisher, id)

  @doc """
  Creates a publisher.

  ## Examples

      iex> create_publisher(%{field: value})
      {:ok, %Publisher{}}

      iex> create_publisher(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_publisher(attrs) do
    %Publisher{}
    |> Publisher.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a publisher.

  ## Examples

      iex> update_publisher(publisher, %{field: new_value})
      {:ok, %Publisher{}}

      iex> update_publisher(publisher, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_publisher(%Publisher{} = publisher, attrs) do
    publisher
    |> Publisher.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a publisher.

  ## Examples

      iex> delete_publisher(publisher)
      {:ok, %Publisher{}}

      iex> delete_publisher(publisher)
      {:error, %Ecto.Changeset{}}

  """
  def delete_publisher(%Publisher{} = publisher) do
    Repo.delete(publisher)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking publisher changes.

  ## Examples

      iex> change_publisher(publisher)
      %Ecto.Changeset{data: %Publisher{}}

  """
  def change_publisher(%Publisher{} = publisher, attrs \\ %{}) do
    Publisher.changeset(publisher, attrs)
  end

  alias Ceres.Authors.AuthorsTitles

  @doc """
  Returns the list of authors_titles.

  ## Examples

      iex> list_authors_titles()
      [%AuthorsTitles{}, ...]

  """
  def list_authors_titles do
    Repo.all(AuthorsTitles)
  end

  @doc """
  Gets a single authors_titles.

  Raises `Ecto.NoResultsError` if the Authors titles does not exist.

  ## Examples

      iex> get_authors_titles!(123)
      %AuthorsTitles{}

      iex> get_authors_titles!(456)
      ** (Ecto.NoResultsError)

  """
  def get_authors_titles!(id), do: Repo.get!(AuthorsTitles, id)

  @doc """
  Creates a authors_titles.

  ## Examples

      iex> create_authors_titles(%{field: value})
      {:ok, %AuthorsTitles{}}

      iex> create_authors_titles(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_authors_titles(attrs) do
    %AuthorsTitles{}
    |> AuthorsTitles.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a authors_titles.

  ## Examples

      iex> update_authors_titles(authors_titles, %{field: new_value})
      {:ok, %AuthorsTitles{}}

      iex> update_authors_titles(authors_titles, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_authors_titles(%AuthorsTitles{} = authors_titles, attrs) do
    authors_titles
    |> AuthorsTitles.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a authors_titles.

  ## Examples

      iex> delete_authors_titles(authors_titles)
      {:ok, %AuthorsTitles{}}

      iex> delete_authors_titles(authors_titles)
      {:error, %Ecto.Changeset{}}

  """
  def delete_authors_titles(%AuthorsTitles{} = authors_titles) do
    Repo.delete(authors_titles)
  end

  def delete_authors_titles_by_title_id(title_id, author_id) do
    from(at in AuthorsTitles, where: at.title_id == ^title_id and at.author_id == ^author_id)
    |> Repo.delete_all()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking authors_titles changes.

  ## Examples

      iex> change_authors_titles(authors_titles)
      %Ecto.Changeset{data: %AuthorsTitles{}}

  """
  def change_authors_titles(%AuthorsTitles{} = authors_titles, attrs \\ %{}) do
    AuthorsTitles.changeset(authors_titles, attrs)
  end

  alias Ceres.Authors.PublishersTitles

  @doc """
  Returns the list of publishers_titles.

  ## Examples

      iex> list_publishers_titles()
      [%PublishersTitles{}, ...]

  """
  def list_publishers_titles do
    Repo.all(PublishersTitles)
  end

  @doc """
  Gets a single publishers_titles.

  Raises `Ecto.NoResultsError` if the Publishers titles does not exist.

  ## Examples

      iex> get_publishers_titles!(123)
      %PublishersTitles{}

      iex> get_publishers_titles!(456)
      ** (Ecto.NoResultsError)

  """
  def get_publishers_titles!(id), do: Repo.get!(PublishersTitles, id)

  @doc """
  Creates a publishers_titles.

  ## Examples

      iex> create_publishers_titles(%{field: value})
      {:ok, %PublishersTitles{}}

      iex> create_publishers_titles(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_publishers_titles(attrs) do
    %PublishersTitles{}
    |> PublishersTitles.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a publishers_titles.

  ## Examples

      iex> update_publishers_titles(publishers_titles, %{field: new_value})
      {:ok, %PublishersTitles{}}

      iex> update_publishers_titles(publishers_titles, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_publishers_titles(%PublishersTitles{} = publishers_titles, attrs) do
    publishers_titles
    |> PublishersTitles.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a publishers_titles.

  ## Examples

      iex> delete_publishers_titles(publishers_titles)
      {:ok, %PublishersTitles{}}

      iex> delete_publishers_titles(publishers_titles)
      {:error, %Ecto.Changeset{}}

  """
  def delete_publishers_titles(%PublishersTitles{} = publishers_titles) do
    Repo.delete(publishers_titles)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking publishers_titles changes.

  ## Examples

      iex> change_publishers_titles(publishers_titles)
      %Ecto.Changeset{data: %PublishersTitles{}}

  """
  def change_publishers_titles(%PublishersTitles{} = publishers_titles, attrs \\ %{}) do
    PublishersTitles.changeset(publishers_titles, attrs)
  end

    @doc """
  Gets the author associated with a given title ID.

  ## Examples

      iex> get_author_by_title_id(123)
      %Author{}

      iex> get_author_by_title_id(456)
      nil

  """
  def get_author_by_title_id(title_id) do
    Repo.get_by(AuthorsTitles, title_id: title_id)
    |> Repo.preload(:author)
    |> Map.get(:author)
  end

  @doc """
  Gets authors whose names match the given name (case-insensitive).

  """
  def get_authors_by_name(name) do
    query = from a in Author,
            where: ilike(a.name, ^"%#{name}%")
    Repo.all(query)
  end
end

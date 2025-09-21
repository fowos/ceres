defmodule Ceres.Tags do
  @moduledoc """
  The Tags context.
  """

  import Ecto.Query, warn: false
  alias Ceres.Repo

  alias Ceres.Tags.Tag

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

      iex> list_tags(limit: 10)
      [%Tag{}, ...]

      iex> list_tags(offset: 10)
      [%Tag{}, ...]

      iex> list_tags(limit: 10, offset: 10)
      [%Tag{}, ...]

  """
  def list_tags(opts \\ []) do
    limit = Keyword.get(opts, :limit, 1000)
    offset = Keyword.get(opts, :offset, 0)

    query = from t in Tag, limit: ^limit, offset: ^offset

    Repo.all(query)
  end


  @doc """
  Returns the list of tags ordered by title count.

  ## Examples

      iex> list_tags_order_by_title_count()
      [%Tag{} | term()]
  """
  @spec list_tags_order_by_title_count() :: [Ceres.Tags.Tag.t() | term()]
  def list_tags_order_by_title_count do
    query =
      from t in Ceres.Tags.Tag,
      left_join: tt in Ceres.Tags.TitlesTags, on: tt.tag_id == t.id,
      group_by: t.id,
      order_by: [desc: count(tt.title_id)],
      select_merge: %{titles_count: count(tt.title_id)}

    Repo.all(query)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{data: %Tag{}}

  """
  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end

  alias Ceres.Tags.TitlesTags

  @doc """
  Returns the list of titles_tags.

  ## Examples

      iex> list_titles_tags()
      [%TitlesTags{}, ...]

  """
  def list_titles_tags do
    Repo.all(TitlesTags)
  end

  @doc """
  Gets a single titles_tags.

  Raises `Ecto.NoResultsError` if the Titles tags does not exist.

  ## Examples

      iex> get_titles_tags!(123)
      %TitlesTags{}

      iex> get_titles_tags!(456)
      ** (Ecto.NoResultsError)

  """
  def get_titles_tags!(id), do: Repo.get!(TitlesTags, id)

  @doc """
  Creates a titles_tags.

  ## Examples

      iex> create_titles_tags(%{field: value})
      {:ok, %TitlesTags{}}

      iex> create_titles_tags(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_titles_tags(attrs) do
    %TitlesTags{}
    |> TitlesTags.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a titles_tags.

  ## Examples

      iex> update_titles_tags(titles_tags, %{field: new_value})
      {:ok, %TitlesTags{}}

      iex> update_titles_tags(titles_tags, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_titles_tags(%TitlesTags{} = titles_tags, attrs) do
    titles_tags
    |> TitlesTags.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a titles_tags.

  ## Examples

      iex> delete_titles_tags(titles_tags)
      {:ok, %TitlesTags{}}

      iex> delete_titles_tags(titles_tags)
      {:error, %Ecto.Changeset{}}

  """
  def delete_titles_tags(%TitlesTags{} = titles_tags) do
    Repo.delete(titles_tags)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking titles_tags changes.

  ## Examples

      iex> change_titles_tags(titles_tags)
      %Ecto.Changeset{data: %TitlesTags{}}

  """
  def change_titles_tags(%TitlesTags{} = titles_tags, attrs \\ %{}) do
    TitlesTags.changeset(titles_tags, attrs)
  end


  def get_tags_by_part_name(name) do
    query = from a in Tag,
            where: ilike(a.name, ^"%#{name}%")
    Repo.all(query)
  end

  @doc """
  Get tag by name

  ## Examples

      iex> get_tag_by_name("name")
      %Tag{}
  """
  @spec get_tag_by_name(String.t()) :: Tag.t() | term() | nil
  def get_tag_by_name(name) do
    query = from t in Tag, where: t.name == ^name
    Repo.one(query)
  end

  def get_titles_tags_by_ids(title_id, tag_id) do
    query = from t in TitlesTags, where: t.title_id == ^title_id, where: t.tag_id == ^tag_id
    Repo.one(query)
  end
end

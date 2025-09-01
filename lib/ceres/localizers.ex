defmodule Ceres.Localizers do
  @moduledoc """
  The Localizers context.
  """

  import Ecto.Query, warn: false
  alias Ceres.Repo

  alias Ceres.Localizers.Localizer

  @doc """
  Returns the list of localizers.

  ## Examples

      iex> list_localizers()
      [%Localizer{}, ...]

  """
  def list_localizers do
    Repo.all(Localizer)
  end

  @doc """
  Gets a single localizer.

  Raises `Ecto.NoResultsError` if the Localizer does not exist.

  ## Examples

      iex> get_localizer!(123)
      %Localizer{}

      iex> get_localizer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_localizer!(id), do: Repo.get!(Localizer, id)

  @doc """
  Creates a localizer.

  ## Examples

      iex> create_localizer(%{field: value})
      {:ok, %Localizer{}}

      iex> create_localizer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_localizer(attrs) do
    %Localizer{}
    |> Localizer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a localizer.

  ## Examples

      iex> update_localizer(localizer, %{field: new_value})
      {:ok, %Localizer{}}

      iex> update_localizer(localizer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_localizer(%Localizer{} = localizer, attrs) do
    localizer
    |> Localizer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a localizer.

  ## Examples

      iex> delete_localizer(localizer)
      {:ok, %Localizer{}}

      iex> delete_localizer(localizer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_localizer(%Localizer{} = localizer) do
    Repo.delete(localizer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking localizer changes.

  ## Examples

      iex> change_localizer(localizer)
      %Ecto.Changeset{data: %Localizer{}}

  """
  def change_localizer(%Localizer{} = localizer, attrs \\ %{}) do
    Localizer.changeset(localizer, attrs)
  end

  alias Ceres.Localizers.LocalizersComics

  @doc """
  Returns the list of localizers_comics.

  ## Examples

      iex> list_localizers_comics()
      [%LocalizersComics{}, ...]

  """
  def list_localizers_comics do
    Repo.all(LocalizersComics)
  end

  @doc """
  Gets a single localizers_comics.

  Raises `Ecto.NoResultsError` if the Localizers comics does not exist.

  ## Examples

      iex> get_localizers_comics!(123)
      %LocalizersComics{}

      iex> get_localizers_comics!(456)
      ** (Ecto.NoResultsError)

  """
  def get_localizers_comics!(id), do: Repo.get!(LocalizersComics, id)

  @doc """
  Creates a localizers_comics.

  ## Examples

      iex> create_localizers_comics(%{field: value})
      {:ok, %LocalizersComics{}}

      iex> create_localizers_comics(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_localizers_comics(attrs) do
    %LocalizersComics{}
    |> LocalizersComics.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a localizers_comics.

  ## Examples

      iex> update_localizers_comics(localizers_comics, %{field: new_value})
      {:ok, %LocalizersComics{}}

      iex> update_localizers_comics(localizers_comics, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_localizers_comics(%LocalizersComics{} = localizers_comics, attrs) do
    localizers_comics
    |> LocalizersComics.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a localizers_comics.

  ## Examples

      iex> delete_localizers_comics(localizers_comics)
      {:ok, %LocalizersComics{}}

      iex> delete_localizers_comics(localizers_comics)
      {:error, %Ecto.Changeset{}}

  """
  def delete_localizers_comics(%LocalizersComics{} = localizers_comics) do
    Repo.delete(localizers_comics)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking localizers_comics changes.

  ## Examples

      iex> change_localizers_comics(localizers_comics)
      %Ecto.Changeset{data: %LocalizersComics{}}

  """
  def change_localizers_comics(%LocalizersComics{} = localizers_comics, attrs \\ %{}) do
    LocalizersComics.changeset(localizers_comics, attrs)
  end
end

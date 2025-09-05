defmodule Ceres.Consumers do
  @moduledoc """
  The Consumers context.
  """

  import Ecto.Query, warn: false
  alias Ceres.Repo

  alias Ceres.Consumers.Consumer


  @doc """
  Returns the list of consumers.

  ## Examples

      iex> list_consumers(scope)
      [%Consumer{}, ...]

  """
  def list_consumers() do
    Repo.all_by(Consumer)
  end

  @doc """
  Gets a single consumer.

  Raises `Ecto.NoResultsError` if the Consumer does not exist.

  ## Examples

      iex> get_consumer!(scope, 123)
      %Consumer{}

      iex> get_consumer!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_consumer!(id) do
    Repo.get_by!(Consumer, id: id)
  end

  @doc """
  Creates a consumer.

  ## Examples

      iex> create_consumer(scope, %{field: value})
      {:ok, %Consumer{}}

      iex> create_consumer(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_consumer(attrs) do
    with {:ok, consumer = %Consumer{}} <-
           %Consumer{}
           |> Consumer.changeset(attrs)
           |> Repo.insert() do
      {:ok, consumer}
    end
  end

  @doc """
  Updates a consumer.

  ## Examples

      iex> update_consumer(scope, consumer, %{field: new_value})
      {:ok, %Consumer{}}

      iex> update_consumer(scope, consumer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_consumer(%Consumer{} = consumer, attrs) do
    with {:ok, consumer = %Consumer{}} <-
           consumer
           |> Consumer.changeset(attrs)
           |> Repo.update() do
      {:ok, consumer}
    end
  end

  @doc """
  Deletes a consumer.

  ## Examples

      iex> delete_consumer(scope, consumer)
      {:ok, %Consumer{}}

      iex> delete_consumer(scope, consumer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_consumer(%Consumer{} = consumer) do
    with {:ok, consumer = %Consumer{}} <-
           Repo.delete(consumer) do
      {:ok, consumer}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking consumer changes.

  ## Examples

      iex> change_consumer(scope, consumer)
      %Ecto.Changeset{data: %Consumer{}}

  """
  def change_consumer(%Consumer{} = consumer, attrs \\ %{}) do
    Consumer.changeset(consumer, attrs)
  end

  alias Ceres.Consumers.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end

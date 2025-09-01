defmodule Ceres.Consumers do
  @moduledoc """
  The Consumers context.
  """

  import Ecto.Query, warn: false
  alias Ceres.Repo

  alias Ceres.Consumers.Consumer
  alias Ceres.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any consumer changes.

  The broadcasted messages match the pattern:

    * {:created, %Consumer{}}
    * {:updated, %Consumer{}}
    * {:deleted, %Consumer{}}

  """
  def subscribe_consumers(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Ceres.PubSub, "user:#{key}:consumers")
  end

  defp broadcast_consumer(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Ceres.PubSub, "user:#{key}:consumers", message)
  end

  @doc """
  Returns the list of consumers.

  ## Examples

      iex> list_consumers(scope)
      [%Consumer{}, ...]

  """
  def list_consumers(%Scope{} = scope) do
    Repo.all_by(Consumer, user_id: scope.user.id)
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
  def get_consumer!(%Scope{} = scope, id) do
    Repo.get_by!(Consumer, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a consumer.

  ## Examples

      iex> create_consumer(scope, %{field: value})
      {:ok, %Consumer{}}

      iex> create_consumer(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_consumer(%Scope{} = scope, attrs) do
    with {:ok, consumer = %Consumer{}} <-
           %Consumer{}
           |> Consumer.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_consumer(scope, {:created, consumer})
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
  def update_consumer(%Scope{} = scope, %Consumer{} = consumer, attrs) do
    true = consumer.user_id == scope.user.id

    with {:ok, consumer = %Consumer{}} <-
           consumer
           |> Consumer.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_consumer(scope, {:updated, consumer})
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
  def delete_consumer(%Scope{} = scope, %Consumer{} = consumer) do
    true = consumer.user_id == scope.user.id

    with {:ok, consumer = %Consumer{}} <-
           Repo.delete(consumer) do
      broadcast_consumer(scope, {:deleted, consumer})
      {:ok, consumer}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking consumer changes.

  ## Examples

      iex> change_consumer(scope, consumer)
      %Ecto.Changeset{data: %Consumer{}}

  """
  def change_consumer(%Scope{} = scope, %Consumer{} = consumer, attrs \\ %{}) do
    true = consumer.user_id == scope.user.id

    Consumer.changeset(consumer, attrs, scope)
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

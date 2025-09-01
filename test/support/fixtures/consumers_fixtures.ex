defmodule Ceres.ConsumersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ceres.Consumers` context.
  """

  @doc """
  Generate a unique consumer public_key.
  """
  def unique_consumer_public_key, do: "some public_key#{System.unique_integer([:positive])}"

  @doc """
  Generate a consumer.
  """
  def consumer_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "some name",
        public_key: unique_consumer_public_key(),
        role: 42
      })

    {:ok, consumer} = Ceres.Consumers.create_consumer(scope, attrs)
    consumer
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        text: "some text"
      })
      |> Ceres.Consumers.create_comment()

    comment
  end
end

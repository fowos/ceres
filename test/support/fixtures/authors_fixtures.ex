defmodule Ceres.AuthorsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ceres.Authors` context.
  """
alias Ceres.TitlesFixtures

  @doc """
  Generate a author.
  """
  def author_fixture(attrs \\ %{}) do
    {:ok, author} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Ceres.Authors.create_author()

    author
  end

  @doc """
  Generate a publisher.
  """
  def publisher_fixture(attrs \\ %{}) do
    {:ok, publisher} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Ceres.Authors.create_publisher()

    publisher
  end

  @doc """
  Generate a authors_titles.
  """
  def authors_titles_fixture(attrs \\ %{}) do
    {:ok, authors_titles} =
      attrs
      |> Enum.into(%{
        author_id: author_fixture().id,
        title_id: TitlesFixtures.title_fixture().id,
        author_role: attrs[:author_role] || :art
      })
      |> Ceres.Authors.create_authors_titles()

    authors_titles
  end

  @doc """
  Generate a publishers_titles.
  """
  def publishers_titles_fixture(attrs \\ %{}) do
    {:ok, publishers_titles} =
      attrs
      |> Enum.into(%{
        publisher_id: attrs[:publisher_id] || publisher_fixture().id,
        title_id: attrs[:title_id] || TitlesFixtures.title_fixture().id
      })
      |> Ceres.Authors.create_publishers_titles()

    publishers_titles
  end
end

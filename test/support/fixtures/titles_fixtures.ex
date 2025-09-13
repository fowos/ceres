defmodule Ceres.TitlesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ceres.Titles` context.
  """

  @doc """
  Generate a unique title original_name.
  """
  def unique_title_original_name, do: "some original_name#{System.unique_integer([:positive])}"

  @doc """
  Generate a title.
  """
  def title_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        original_name: unique_title_original_name(),
        type: 42
      })

    {:ok, title} = Ceres.Titles.create_title(scope, attrs)
    title
  end

  @doc """
  Generate a comic.
  """
  def comic_fixture(attrs \\ %{}) do
    {:ok, comic} =
      attrs
      |> Enum.into(%{
        description: "some description",
        language: 42,
        name: "some name",
        views: 42
      })
      |> Ceres.Titles.create_comic()

    comic
  end

  @doc """
  Generate a chapter.
  """
  def chapter_fixture(attrs \\ %{}) do
    {:ok, chapter} =
      attrs
      |> Enum.into(%{
        number: 42,
        volume: 42
      })
      |> Ceres.Titles.create_chapter()

    chapter
  end

  @doc """
  Generate a page.
  """
  def page_fixture(attrs \\ %{}) do
    {:ok, page} =
      attrs
      |> Enum.into(%{
        number: 42,
        source: "some source"
      })
      |> Ceres.Titles.create_page()

    page
  end

  @doc """
  Generate a cover.
  """
  def cover_fixture(attrs \\ %{}) do
    {:ok, cover} =
      attrs
      |> Enum.into(%{
        source: "some source"
      })
      |> Ceres.Titles.create_cover()

    cover
  end
end

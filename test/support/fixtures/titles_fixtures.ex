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
  def title_fixture(attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        original_name: unique_title_original_name(),
        type: :manga
      })

    {:ok, title} = Ceres.Titles.create_title(attrs)
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
        language: :en,
        name: "some name",
        title_id: attrs[:title_id] || title_fixture().id
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
        comic_id: attrs[:comic_id] || comic_fixture().id,
        number: attrs[:number] || 42,
        volume: attrs[:volume] || 42
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
        chapter_id: attrs[:chapter_id] || chapter_fixture().id,
        number: attrs[:number] || 42,
        source: attrs[:source] || "some source"
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
        comic_id: attrs[:comic_id] || comic_fixture().id,
        source: "some source"
      })
      |> Ceres.Titles.create_cover()

    cover
  end
end

defmodule Ceres.TagsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ceres.Tags` context.
  """

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Ceres.Tags.create_tag()

    tag
  end

  @doc """
  Generate a titles_tags.
  """
  def titles_tags_fixture(attrs \\ %{}) do
    {:ok, titles_tags} =
      attrs
      |> Enum.into(%{

      })
      |> Ceres.Tags.create_titles_tags()

    titles_tags
  end
end

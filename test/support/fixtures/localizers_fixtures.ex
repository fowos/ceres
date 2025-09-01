defmodule Ceres.LocalizersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ceres.Localizers` context.
  """

  @doc """
  Generate a localizer.
  """
  def localizer_fixture(attrs \\ %{}) do
    {:ok, localizer} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Ceres.Localizers.create_localizer()

    localizer
  end

  @doc """
  Generate a localizers_comics.
  """
  def localizers_comics_fixture(attrs \\ %{}) do
    {:ok, localizers_comics} =
      attrs
      |> Enum.into(%{

      })
      |> Ceres.Localizers.create_localizers_comics()

    localizers_comics
  end
end

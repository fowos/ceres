defmodule CeresWeb.Api.Titles.TitlesJSON do
  alias Ceres.Titles.Title
  alias Ceres.Titles.Comic

  def index(%{titles: titles}) do
    %{data: for(title <- titles, do: data(title))}
  end

  def show(%{title: title}) do
    %{data: data(title)}
  end

  defp data(%Title{} = title) do
    %{
      id: title.id,
      original_name: title.original_name
    }
  end
end

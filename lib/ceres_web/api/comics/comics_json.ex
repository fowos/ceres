defmodule CeresWeb.Api.Comics.ComicsJSON do
  alias Ceres.Titles.Comic

  def index(%{comics: comics}) do
    %{data: for(comic <- comics, do: data(comic))}
  end

  def show(%{comic: comic}) do
    %{data: data(comic)}
  end

  defp data(%Comic{} = comic) do
    %{
      id: comic.id,
      title_id: comic.title_id,
      name: comic.name,
      language: comic.language,
      localizers: localizers(comic),
      chapters: chapters(comic)
    }
  end

  defp localizers(%Comic{} = comic) do
    Enum.map(comic.localizers, fn local ->
       %{
         id: local.id,
         name: local.name
       }
    end)
  end

  defp chapters(%Comic{} = comic) do
    Enum.map(comic.chapters, fn chapter ->
      %{
        id: chapter.id,
        volume: chapter.volume,
        number: chapter.number
      }
    end)
  end
end

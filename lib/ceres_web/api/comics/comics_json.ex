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
      chapters: chapters(comic),
      publishers: publishers(comic),
      authors: authors(comic),
      tags: tags(comic)
    }
  end

  defp localizers(%Comic{} = comic) do
    Enum.map(comic.localizers, fn local ->
       %{
         id: local.id,
         name: local.name,
         description: local.description
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

  defp authors(%Comic{} = comic) do
    Enum.map(comic.title.authors, fn author ->
      %{
        id: author.id,
        name: author.name,
        description: author.description
      }
    end)
  end

  defp publishers(%Comic{} = comic) do
    Enum.map(comic.title.publishers, fn publisher ->
      %{
        id: publisher.id,
        name: publisher.name,
        description: publisher.description
      }
    end)
  end

  defp tags(%Comic{} = comic) do
    Enum.map(comic.title.tags, fn tag ->
      %{
        id: tag.id,
        name: tag.name,
      }
    end)
  end


end

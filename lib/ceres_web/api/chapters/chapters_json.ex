defmodule CeresWeb.Api.Chapters.ChaptersJSON do
alias Ceres.Titles.Chapter

  def index(%{chapters: chapters}) do
    %{data: for(chapter <- chapters, do: data(chapter))}
  end

  def show(%{chapter: chapter}) do
    %{data: data(chapter)}
  end

  defp data(%Chapter{} = chapter) do
    %{
      id: chapter.id,
      volume: chapter.volume,
      number: chapter.number,
      comic_id: chapter.comic_id,
      pages: pages(chapter)
    }
  end

  defp pages(%Chapter{} = chapter) do
    Enum.map(chapter.pages, fn page ->
      %{
        id: page.id,
        number: page.number,
        source: page.source
      }
    end)
  end
end

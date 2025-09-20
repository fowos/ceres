defmodule CeresWeb.Api.Chapters.ChaptersJSON do
alias Ceres.Titles.Chapter

  def index(%{chapters: chapters}) do
    %{data: for(chapter <- chapters, do: data(chapter))}
  end

  def show(%{chapter: chapter}) do
    %{data: data(chapter)}
  end

  defp data(%Chapter{} = chapter) do
    raise "Not implemented"
  end
end

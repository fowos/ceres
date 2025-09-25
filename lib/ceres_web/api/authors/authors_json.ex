defmodule CeresWeb.Api.Authors.AuthorsJSON do
alias Ceres.Authors.Author
alias Ceres.Titles.Chapter

  def index(%{authors: authors}) do
    %{data: for(author <- authors, do: data(author))}
  end

  def show(%{author: author}) do
    %{data: data(author)}
  end

  defp data(%Author{} = author) do
    %{
      id: author.id,
      name: author.name,
      description: author.description
    }
  end
end

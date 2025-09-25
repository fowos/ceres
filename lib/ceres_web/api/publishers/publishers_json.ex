defmodule CeresWeb.Api.Publishers.PublishersJSON do
alias Ceres.Authors.Publisher
alias Ceres.Titles.Chapter

  def index(%{publishers: publishers}) do
    %{data: for(publisher <- publishers, do: data(publisher))}
  end

  def show(%{publisher: publisher}) do
    %{data: data(publisher)}
  end

  defp data(%Publisher{} = publisher) do
    %{
      id: publisher.id,
      name: publisher.name,
      description: publisher.description
    }
  end
end

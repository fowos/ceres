defmodule CeresWeb.Api.Pages.PagesJSON do
  alias Ceres.Titles.Page

  def index(%{pages: pages}) do
    %{data: for(page <- pages, do: data(page))}
  end

  def show(%{page: page}) do
    %{data: data(page)}
  end


  defp data(%Page{} = page) do
    %{
      id: page.id,
      number: page.number,
      source: page.source
    }
  end
end

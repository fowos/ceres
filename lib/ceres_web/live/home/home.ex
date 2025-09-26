defmodule CeresWeb.Home.Home do
alias Ceres.Titles
  use CeresWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(:page_title, "Home")
    |> assign(:count_comics, Titles.count_comics())

    {:ok, socket}
  end
end

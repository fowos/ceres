defmodule CeresWeb.Components.NavbarLive do
  use Phoenix.LiveComponent
  use CeresWeb, :verified_routes


  def render(assigns) do
    # IO.inspect(pages, label: "PAGES IN NAVBAR")
    ~H"""
    <div class="p-4 bg-base-200 rounded-lg mx-auto">
      <p class="font-bold">Ceres</p>
      <div class="divider"></div>
      <div class="font-medium flex flex-col gap-4 mx-auto w-full">
        <a class="whitespace-nowrap" href={~p"/home"}>Home</a>
      </div>
    </div>
    """
  end
end

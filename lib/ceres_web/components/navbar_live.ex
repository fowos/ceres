defmodule CeresWeb.Components.NavbarLive do
  use Phoenix.LiveComponent
  use CeresWeb, :verified_routes
  use CeresWeb, :html


  def render(assigns) do
    # IO.inspect(pages, label: "PAGES IN NAVBAR")
    ~H"""
    <div class="p-4 bg-base-200 w-full md:min-w-60 rounded-lg border-base-300 border-1 mx-auto">
      <div class="flex flex-row rounded-lg bg-base-300">
        <img src={~p"/images/logo.png"} alt="ceres logo" class="w-16 h-auto" />
        <p class="font-bold my-auto text-base-content">Ceres</p>
      </div>

      <div class="divider"></div>

      <div class="font-medium flex flex-row gap-2 mx-auto w-full">
        <div class="text-base-content hover:text-primary duration-300">
          <.icon name="hero-queue-list" class="size-6" />
          <.link class="whitespace-nowrap" navigate={~p"/titles"}>Titles</.link>
        </div>
      </div>
    </div>
    """
  end
end

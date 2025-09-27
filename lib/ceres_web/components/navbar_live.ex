defmodule CeresWeb.Components.NavbarLive do
  use Phoenix.LiveComponent
  use CeresWeb, :verified_routes
  use CeresWeb, :html

  @pages [
    {"Titles", "hero-queue-list", "titles"},
    {"Comics", "hero-document", "comics"},
    {"Tags", "hero-tag", "tags"}
  ]

  def render(assigns) do

    assigns = %{
      pages: @pages
    }
    ~H"""
    <div class="bg-base-100 w-full md:min-w-50 rounded-lg mx-auto">
      <div class="static md:sticky md:top-4 self-start h-fit">

        <.link
          navigate={~p"/"}
          class="group flex flex-row gap-4 rounded-lg bg-base-200 p-2"
        >
          <img src={~p"/images/logo.png"} alt="ceres logo" class="w-8 h-auto transition-transform duration-600 group-hover:rotate-[360deg]" />
          <p class="font-bold my-auto text-base-content group-hover:text-primary duration-300">Ceres</p>
        </.link>

        <%!-- <div class="divider"></div> --%>

        <div class="font-medium flex flex-col gap-2 mx-auto w-full mt-4">

          <%= for {name, icon, path} <- @pages do%>
            <.link
              class="whitespace-nowrap text-base-content hover:text-primary duration-300 w-full bg-base-200 p-2 rounded-lg"
              navigate={~p"/#{path}"}
            >
              <.icon name={icon} class="size-6 me-2" />
              {name}
            </.link>

          <% end %>

        </div>

        <%!-- <div class="divider"></div> --%>
      </div>
    </div>
    """
  end
end

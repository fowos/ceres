defmodule CeresWeb.Titles.Components.Filter do
  use Phoenix.LiveComponent
alias Ceres.Tags
  use CeresWeb, :html

  @impl Phoenix.LiveComponent
  def mount(socket) do
    socket = socket
    |> assign(:type_options, [{"Any", :any}, {"Manga", :manga}, {"Manhwa", :manhwa}, {"Comic", :comic}, {"Novel", :novel}])
    |> assign(:type, :any)
    |> assign(:tags, [])
    |> assign(:results, [])

    {:ok, socket}
  end


  @impl Phoenix.LiveComponent
  def handle_event("type-change", %{"type" => type}, socket) do
    socket = socket
    |> assign(:type, String.to_existing_atom(type))
    {:noreply, socket}
  end

  @impl Phoenix.LiveComponent
  def handle_event("search-tag-change", %{"search-tag" => search}, socket) do
    socket = socket
    |> assign(:results, Tags.get_tags_by_part_name(search))
    {:noreply, socket}
  end

  @impl Phoenix.LiveComponent
  def handle_event("add-tag", %{"id" => id}, socket) do
    socket = socket
    |> assign(:tags, [Tags.get_tag!(id) | socket.assigns.tags] |> Enum.uniq_by(&(&1.id)))
    |> assign(:results, [])
    {:noreply, socket}
  end

  @impl Phoenix.LiveComponent
  def handle_event("remove-tag", %{"id" => id}, socket) do
    socket = socket
    |> assign(:tags, socket.assigns.tags -- [Tags.get_tag!(id)])
    {:noreply, socket}
  end

  @impl Phoenix.LiveComponent
  def handle_event("search-with-filter", _params, socket) do
    tags_ids = socket.assigns.tags
    |> Enum.map(&(&1.id))

    send(self(), {:filtered, tags_ids, socket.assigns.type})
    {:noreply, socket}
  end

end

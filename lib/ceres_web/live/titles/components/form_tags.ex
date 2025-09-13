defmodule CeresWeb.TitlesList.Components.FormTags do
  use Phoenix.LiveComponent
  require Logger
  alias Ceres.Tags.Tag
  alias Ceres.Tags
  use CeresWeb, :html


  attr :tags, :list, required: true

  @impl true
  def mount(socket) do
    socket = socket
    |> assign(:results, [])
    |> assign(:search, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    case search do
      "" -> {:noreply, socket |> assign(:results, [])}
      search ->
        tags = Tags.get_tags_by_part_name(search)

        socket = socket
        |> assign(:results, tags)

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("save-tag", %{"search" => new}, socket) do
    socket = socket |> assign(:results, [])
    case new do
      "" -> {:noreply, socket |> assign(:results, [])}
      new ->
        case Tags.create_tag(%{name: new}) do
          {:ok, tag} ->
            send(self(), {:add_tag, tag})

            {:noreply, socket}

          {:error, changeset} ->
            with true <- String.contains?("#{inspect(changeset)}", "already been taken"),
            %Tag{} = tag <- Tags.get_tag_by_name(new)
              do
                send(self(), {:add_tag, tag})
                {:noreply, socket}
              else
                _ -> Logger.error("Error while creating tag \n #{inspect(changeset)}")
                send(self(), {:flash, :error, "Error while creating tag, error: \n #{inspect(changeset.errors)}"})

                {:noreply, socket}
              end

        end
    end
  end

  @impl true
  def handle_event("remove-tag", %{"id" => id}, socket) do
    send(self(), {:remove_tag, Tags.get_tag!(id)})
    {:noreply, socket}
  end

  @impl true
  def handle_event("add-tag", %{"id" => id}, socket) do
    if not Enum.any?(socket.assigns.tags, fn tag -> tag.id == id end) do
      tag = Tags.get_tag!(id)
      Logger.debug("sent")
      send(self(), {:add_tag, tag})
    end

    {:noreply, socket}
  end
end

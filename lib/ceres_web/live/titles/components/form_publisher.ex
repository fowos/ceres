defmodule CeresWeb.TitlesList.Components.FormPublisher do
  use Phoenix.LiveComponent
  alias Ceres.Authors.Publisher
  use CeresWeb, :html

  alias Ceres.Authors

  attr :publishers, :list, required: true

  @impl true
  def mount(socket) do
    socket = socket
    |> assign(:results, [])
    |> assign(:changeset, Authors.change_publisher(%Publisher{}) |> to_form())
    |> assign(:search, nil)

    {:ok, socket}
  end


  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    if search == "" || search == nil do
      socket = socket
      |> assign(:results, [])

      {:noreply, socket}
    else
      socket = socket
      |> assign(:results, Authors.get_publishers_by_part_name(search))

      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("select", %{"id" => id}, socket) do
    send(self(), {:add_publisher, Authors.get_publisher!(id)})

    socket = socket
    |> assign(:search, nil)
    |> assign(:results, [])

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"publisher" => publisher}, socket) do
    changeset =
      Authors.change_publisher(%Publisher{}, publisher)
      |> Map.put(:action, :validate)

    {:noreply,
    socket
    |> assign(:changeset, to_form(changeset))}
  end

  @impl true
  def handle_event("save", %{"publisher" => publisher_attrs}, socket) do
    IO.inspect(publisher_attrs, label: "publishers attrs")
    case Authors.create_publisher(publisher_attrs) do
      {:ok, publisher} ->
        send(self(), {:add_publisher, publisher})

        socket = socket
        |> assign(:changeset, Authors.change_publisher(%Publisher{}) |> to_form())

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
        socket
        |> assign(:changeset, to_form(changeset))}
    end
  end

  @impl true
  def handle_event("clear-form", _params, socket), do:
    {:noreply, assign(socket, :changeset, Authors.change_publisher(%Publisher{}) |> to_form())}

  @impl true
  def handle_event("remove-publisher", %{"id" => id} = params, socket) do
    send(self(), {:remove_publisher, id})

    {:noreply, socket}
  end
end

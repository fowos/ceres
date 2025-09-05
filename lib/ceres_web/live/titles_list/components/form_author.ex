defmodule CeresWeb.TitlesList.FormAuthor do
  use Phoenix.LiveComponent
  alias Ceres.Authors.Author
  use CeresWeb, :html

  alias Ceres.Authors

  attr :authors, :list, required: true

  @impl true
  def mount(socket) do
    socket = socket
    |> assign(:results, [])
    |> assign(:changeset, Authors.change_author(%Author{}) |> to_form())
    |> assign(:search, nil)
    |> assign(:type_options, [{"Art", :art}, {"Story", :story}, {"Story & Art", :story_art}])


    {:ok, socket}
  end


  @impl true
  def handle_event("search", %{"search" => search} = params, socket) do
    if search == "" || search == nil do
      socket = socket
      |> assign(:results, [])

      {:noreply, socket}
    else
      socket = socket
      |> assign(:results, Authors.get_authors_by_name(search))

      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("select", %{"id" => author_id, "role" => role} = params, socket) do
    send(self(), {:add_author, Authors.get_author!(author_id), role})

    socket = socket
    |> assign(:search, nil)
    |> assign(:results, [])

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"author" => author} = params, socket) do
    changeset =
      Authors.change_author(%Author{}, author)
      |> Map.put(:action, :validate)

    {:noreply,
    socket
    |> assign(:changeset, to_form(changeset))}
  end

  @impl true
  def handle_event("save", %{"author" => author_attrs} = params, socket) do

    case Authors.create_author(author_attrs) do
      {:ok, author} ->
        send(self(), {:add_author, author, author_attrs["author_role"]})

        socket = socket
        |> assign(:changeset, Authors.change_author(%Author{}) |> to_form())

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
        socket
        |> assign(:changeset, to_form(changeset))}
    end
  end

  @impl true
  def handle_event("clear-form", _params, socket), do:
    {:noreply, assign(socket, :changeset, Authors.change_author(%Author{}) |> to_form())}

  @impl true
  def handle_event("remove-author", %{"id" => author_id} = params, socket) do
    send(self(), {:remove_author, author_id})

    {:noreply, socket}
  end
end

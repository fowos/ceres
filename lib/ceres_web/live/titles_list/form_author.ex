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

    {:ok, socket}
  end


  @impl true
  def handle_event("search", %{"search" => search} = params, socket) do
    if search == "" do
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
  def handle_event("validate", %{"author" => author} = params, socket) do
    changeset =
      Authors.change_author(%Author{}, author)
      |> Map.put(:action, :validate)

    {:noreply,
    socket
    |> assign(:changeset, to_form(changeset))}
  end
end

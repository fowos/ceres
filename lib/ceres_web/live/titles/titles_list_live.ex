defmodule CeresWeb.TitlesList.TitlesListLive do
alias Ceres.Repo
  use CeresWeb, :live_view

  alias Ceres.Titles
  alias Ceres.Titles.Title

  require Logger


  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    socket = socket
    |> stream(:titles, Titles.list_titles() |> Repo.preload([:comics, :tags]))
    |> assign(:title_changeset, Titles.Title.changeset(%Title{}, %{}))
    {:ok, socket}
  end


  @impl Phoenix.LiveView
  def handle_event("open_modal", _params, socket) do
    {:noreply, assign(socket, :modal, :new_title)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"title" => params}, socket) do
    changeset =
      %Title{}
      |> Title.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", %{"title" => params}, socket) do
    case Titles.create_title(params) do
      {:ok, _title} ->
        {:noreply,
         socket
         |> assign(:titles, Titles.list_titles())
         |> assign(:modal, nil)
         |> put_flash(:info, "Title created successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("delete-title", %{"id" => id}, socket) do
    title = Titles.get_title!(id)
    case Titles.delete_title(title) do
      {:ok, title} ->
        {:noreply,
         socket
         |> stream_delete(:titles, title)
         |> put_flash(:info, "Title deleted successfully")}
      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error("Error while deleting title. \n#{inspect(changeset)}")
        {:noreply, socket |> put_flash(:error, "Error while deleting title. Please check server logs")}
    end
  end



  @impl Phoenix.LiveView
  def handle_info({:modal_closed, _id}, socket) do
    {:noreply, assign(socket, :modal, nil)}
  end

end

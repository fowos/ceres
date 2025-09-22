defmodule CeresWeb.TitlesList.TitlesListLive do
  alias Ceres.Tags
  alias Hex.API.Key
  alias Ceres.Repo
  use CeresWeb, :live_view

  alias Ceres.Titles
  alias Ceres.Titles.Title

  require Logger


  @impl Phoenix.LiveView
  def mount(params, _session, socket) do

    socket = socket
    |> assign(:page_title, "Titles")
    |> stream(:titles, Titles.list_titles(limit: 20, offset: 0) |> Repo.preload([:comics, :tags]))
    |> assign(:title_changeset, Titles.Title.changeset(%Title{}, %{}))
    |> assign(:limit, 20)
    |> assign(:offset, 0)
    |> assign(:filters, [])

    {:ok, socket}
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
  def handle_event("load-more", _params, socket) do
    offset = socket.assigns.offset + socket.assigns.limit
    titles = Titles.list_titles(offset: offset, limit: socket.assigns.limit, filter_by: socket.assigns.filters) |> Repo.preload([:comics, :tags])
    socket = socket
    |> stream(:titles, titles)
    |> assign(:offset, offset)

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({:filtered, tags_ids, type}, socket) do

    filters = []
    filters = case type do
      :any -> filters
      _ -> Keyword.put(filters, :type, type)
    end

    filters = case tags_ids do
      [] -> filters
      _ -> Keyword.put(filters, :tags, tags_ids)
    end

    socket = socket
    |> assign(:filters, filters)
    |> stream(:titles, titles = Titles.list_titles(limit: 20, offset: 0, filter_by: filters) |> Repo.preload([:comics, :tags]), reset: true)
    {:noreply, socket}
  end

end

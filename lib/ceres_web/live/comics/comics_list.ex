defmodule CeresWeb.Comics.ComicsList do
  use CeresWeb, :live_view

  alias Ceres.Repo
  alias Ceres.Titles

  require Logger

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    comics = Titles.list_comics(offset: 0, limit: 10, order_by: [desc: :inserted_at]) |> Repo.preload([:localizers, :chapters, :cover])

    socket = socket
    |> stream(:comics, comics)
    |> assign(:limit, 10)
    |> assign(:offset, 0)
    # |> assign(:order_by, [desc: :inserted_at])

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("delete-comic", %{"id" => id}, socket) do
    comic = Titles.get_comic!(id)
    case Titles.delete_comic(comic) do
      {:ok, _} ->
        socket = socket
        |> stream_delete(:comics, comic)
        |> put_flash(:info, "Comic deleted successfully")
        {:noreply, socket}
      {:error, changeset} ->
        Logger.error("Error while deleting comic.\n#{inspect(changeset)}")
        socket = socket
        |> put_flash(:error, "Error while deleting comic. Please check server logs")
        {:noreply, socket}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("load-more", _params, socket) do
    offset = socket.assigns.offset + socket.assigns.limit
    comics = Titles.list_comics(offset: offset, limit: socket.assigns.limit) |> Repo.preload([:localizers, :chapters, :cover])
    socket = socket
    |> stream(:comics, comics)
    |> assign(:offset, offset)
    {:noreply, socket}
  end

  defp localizers_names(localizers) do
    Enum.map(localizers, fn l -> l.name end)
    |> Enum.join()
  end

  defp lang_atom_to_string(lang) when is_atom(lang) do
    case lang do
      :en -> "English"
      :jp -> "Japanese"
      :kr -> "Korean"
      :cn -> "Chinese"
      :ru -> "Russian"
      _ ->
        Logger.error("Unknown language #{lang}")
        Atom.to_string(lang)
    end
  end

end

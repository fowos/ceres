defmodule CeresWeb.Comics.ComicsList do
  use CeresWeb, :live_view

  alias Ceres.Repo
  alias Ceres.Titles

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    comics = Titles.list_comics |> Repo.preload([:localizers, :chapters, :cover])

    socket = socket
    |> stream(:comics, comics)

    {:ok, socket}
  end

  @impl true
  def handle_event("delete-comic", %{"id" => id}, socket) do
    comic = Titles.get_comic!(id)
    case Titles.delete_comic(comic) do
      {:ok, _} ->
        {:noreply, stream_delete(socket, :comics, comic)}
      {:error, changeset} ->
        Logger.error("Error while deleting comic. \n#{inspect(changeset)}")
        {:noreply, socket}
    end
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

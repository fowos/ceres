defmodule CeresWeb.Comics.FormEdit do
  require Logger
  alias Ceres.Storage.S3
  alias Ceres.Storage.Converter
  alias Mix.Local
  alias Ceres.Repo
  alias Ceres.Localizers
  alias Ceres.Titles.Comic
  alias Ceres.Titles
  use CeresWeb, :live_view

  @language_options [{"English", :en}, {"Japanese", :jp}, {"Korean", :kr}, {"Chinese", :cn}, {"Russian", :ru}]


  @impl true
  def mount(%{"id" => id}, _session, socket) do
    comic = Titles.get_comic!(id)

    localizers = comic
    |> Repo.preload(:localizers)
    |> Map.get(:localizers)

    socket = socket
    |> assign(:comic, comic)
    |> assign(:form, Titles.change_comic(comic) |> to_form)
    |> assign(:language_options, @language_options)
    |> assign(:localizers_search, nil)
    |> assign(:localizers_results, [])
    |> assign(:localizers, localizers)

    {:ok, socket}
  end

  ### Comic form

  @impl Phoenix.LiveView
  def handle_event("validate", %{"comic" => params}, socket) do
    changeset =
      Titles.change_comic(socket.assigns.comic, params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(:form, to_form(changeset))}
  end

  @impl Phoenix.LiveView
  def handle_event("save", %{"comic" => params}, socket) do
    case Titles.update_comic(socket.assigns.comic, params) do
      {:ok, comic} ->
        {:noreply, redirect(socket, to: "/comics")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(:form, to_form(changeset))}
    end
  end

  ### Localizer search form

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    case search do
      "" -> {:noreply, socket}
      search ->
        socket = socket
        |> assign(:localizers_results, Localizers.get_localizers_by_part_name(search))

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("select-localizer", %{"id" => id}, socket) do
    localizer = Localizers.get_localizer!(id)

    case Enum.any?(socket.assigns.localizers, fn x -> x.id == localizer.id end) do
      true -> {:noreply, socket}
      false ->
        case Localizers.create_localizers_comics(%{localizer_id: localizer.id, comic_id: socket.assigns.comic.id}) do
          {:ok, localizer_comics} ->
            socket = socket
            |> assign(:localizers, socket.assigns.localizers ++ [localizer])
            |> assign(:localizers_results, [])

            {:noreply, socket}

          {:error, %Ecto.Changeset{} = changeset} ->
            Logger.error("Error adding localizer. \n #{inspect(changeset)}")
            {:noreply, socket |> put_flash(:error, "Error adding localizer, please check server logs")}
        end
    end
  end

  @impl true
  def handle_event("remove-localizer", %{"id" => id}, socket) do
    case Enum.any?(socket.assigns.localizers, fn x -> x.id == id end) do
      true ->
        case Localizers.delete_localizers_comics_by_attrs(id, socket.assigns.comic.id) do
          {1, _} ->
            localizers = socket.assigns.localizers
            |> Enum.reject(fn x -> x.id == id end)

            socket = socket
            |> put_flash(:info, "Localizer removed successfully")
            |> assign(:localizers, localizers)
            {:noreply, socket}
        end
    end
  end

end

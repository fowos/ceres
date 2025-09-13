defmodule CeresWeb.Comics.FormNew do
  alias Ceres.Titles.Comic
  alias Ceres.Titles
  use CeresWeb, :live_view

  #  [en: 0, jp: 1, kr: 2, cn: 3, ru: 4]
  @language_options [{"English", :en}, {"Japanese", :jp}, {"Korean", :kr}, {"Chinese", :cn}, {"Russian", :ru}]

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    IO.inspect(params, label: "params")

    comic = case params["id"] do
      nil ->
        %Comic{}
      id ->
        %Comic{title_id: id}
    end


    socket = socket
    |> assign(:language_options, @language_options)
    |> assign(:comic, comic)
    |> assign(:form, Titles.change_comic(comic) |> to_form)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"comic" => params}, socket) do
    changeset =
      Titles.change_comic(socket.assigns.comic, params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(:form, to_form(changeset))}
  end

  @impl Phoenix.LiveView
  def handle_event("save", %{"comic" => params}, socket) do
    case Titles.create_comic(params) do
      {:ok, comic} ->
        {:noreply, redirect(socket, to: "/comics/#{comic.id}/edit")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(:form, to_form(changeset))}
    end
  end
end

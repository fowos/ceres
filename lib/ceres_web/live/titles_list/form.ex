defmodule CeresWeb.TitlesList.Form do
  require Ecto.Query
  alias Ceres.Authors.Author
  alias Ceres.Authors
  use CeresWeb, :live_view

  alias Ceres.Titles
  alias Ceres.Titles.Title
  alias Ceres.Repo


  @impl true
  def mount(params, _session, socket) do
    socket = socket
    |> assign(:return_to, return_to(params["return_to"]))
    |> assign(:type_options, [{"Manga", :manga}, {"Manhwa", :manhwa}, {"Comic", :comic}, {"Novel", :novel}])
    |> apply_action(socket.assigns.live_action, params)

    {:ok, socket}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :new, _params) do
    title = %Title{}

    socket
    |> assign(:page_title, "New Title")
    |> assign(:title, title)
    |> assign(:form, to_form(Titles.change_title(title)))
    |> assign(:authors, [])
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    title = Titles.get_title!(id)

    authors = title |> Repo.preload(:authors) |> Map.get(:authors)

    socket
    |> assign(:page_title, "Edit Title")
    |> assign(:title, title)
    |> assign(:form, to_form(Titles.change_title(title)))
    |> assign(:authors, authors)

  end

  @impl true
  def handle_event("validate", %{"title" => title_params}, socket) do
    changeset =
      Titles.change_title(socket.assigns.title, title_params)
      |> Map.put(:action, :validate)

    {:noreply,
    socket
    |> assign(:form, to_form(changeset))}
    end

  def handle_event("save", %{"title" => title_params}, socket) do
    save_title(socket, socket.assigns.live_action, title_params)
  end


  def handle_event("toggle_new_author", _params, socket) do
    {:noreply, update(socket, :show_new_author, fn show -> !show end)}
  end


  def save_title(socket, :edit, title_params) do
    IO.inspect(socket.assigns.live_action, label: "Live action")
    IO.inspect(title_params, label: "Title params")
    IO.inspect(socket.assigns.title, label: "Socket title")

    case Titles.update_title(socket.assigns.title, title_params) do
      {:ok, title} ->
        {:noreply,
          socket
          |> put_flash(:info, "Title updated successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, title))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def save_title(socket, :new, title_params) do
    case Titles.create_title(title_params) do
      {:ok, title} ->
        {:noreply,
         socket
         |> put_flash(:info, "Title created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, title))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp return_path("index", _mitle), do: ~p"/titles"
  defp return_path("show", title), do: ~p"/titles/#{title}"
end

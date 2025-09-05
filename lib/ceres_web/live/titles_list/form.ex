defmodule CeresWeb.TitlesList.Form do
  require Ecto.Query
  alias Ceres.Authors.Author
  alias Ceres.Authors
  use CeresWeb, :live_view

  alias Ceres.Titles
  alias Ceres.Titles.Title
  alias Ceres.Repo

  require Logger


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

    authors = title
    |> Repo.preload(:authors_titles)
    |> Map.get(:authors_titles)
    |> Enum.map(fn at -> {Repo.preload(at, :author).author, at.author_role} end)

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

  def save_title(socket, :edit, title_params) do
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
        Enum.each(socket.assigns.authors, fn {author, role} ->
          Authors.create_authors_titles(%{
            author_id: author.id,
            title_id: title.id,
            author_role: role_to_atom(role)
          })
        end)

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

  def handle_info({:add_author, author, role}, socket) do

    if author.id in Enum.map(socket.assigns.authors, fn {a, _r} -> a.id end) do
      {:noreply, socket |> put_flash(:error, "Author already added")}
    else
      authors = socket.assigns.authors ++ [{author, role_to_atom(role)}]
      |> Enum.uniq_by(fn {a, _r} -> a.id end)

      case socket.assigns.live_action do
        :new -> {:noreply, assign(socket, :authors, authors)}
        :edit ->
          Authors.create_authors_titles(%{
            author_id: author.id,
            title_id: socket.assigns.title.id,
            author_role: role_to_atom(role)
          })

          socket = socket
          |> put_flash(:info, "Author added successfully")
          |> assign(:authors, authors)

          {:noreply, socket}
      end
    end
  end

  def handle_info({:remove_author, author_id}, socket) do
    authors = socket.assigns.authors

    with {%Author{} = author, _role} <- find_author(authors, author_id) do

      if socket.assigns.live_action == :edit do
        Authors.delete_authors_titles_by_title_id(socket.assigns.title.id, author.id)
      end

      authors = Enum.reject(authors, fn {a, _r} -> a.id == author_id end)

      socket = socket
      |> put_flash(:info, "Author '#{author.name}' removed successfully")
      |> assign(:authors, authors)

      {:noreply, socket}
    else
      _ ->
        Logger.error("Author with id #{author_id} not found in title #{socket.assigns.title.id}")
        {:noreply, socket |> put_flash(:error, "Author not found in title")}
    end
  end

  defp find_author(authors, id), do: Enum.find(authors, fn {a, _r} -> a.id == id end)


  defp role_to_atom("art"), do: :art
  defp role_to_atom("story"), do: :story
  defp role_to_atom("story_art"), do: :story_art
  defp role_to_atom(role) when is_atom(role), do: role
  defp role_to_atom(role) do
    Logger.error("Unknown author role, #{role}")
    raise ArgumentError, "Unknown author role, '#{inspect(role)}'"
  end
end

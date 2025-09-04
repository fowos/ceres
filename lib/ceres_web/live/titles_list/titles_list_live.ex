defmodule CeresWeb.TitlesList.TitlesListLive do
  use CeresWeb, :live_view

  alias Ceres.Titles
  alias Ceres.Titles.Title

  def mount(_params, _session, socket) do
    socket = socket
    |> stream(:titles, Titles.list_titles())
    |> assign(:modal, nil)
    |> assign(:title_changeset, Titles.Title.changeset(%Title{}, %{}))
    {:ok, socket}
  end

  def handle_event("open_modal", _params, socket) do
    {:noreply, assign(socket, :modal, :new_title)}
  end

  def handle_event("validate", %{"title" => params}, socket) do
    changeset =
      %Title{}
      |> Title.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

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

  def handle_info({:modal_closed, _id}, socket) do
    {:noreply, assign(socket, :modal, nil)}
  end

  # defp sort_icon(current_by, current_order, field) do
  #   if current_by == field do
  #     if current_order == :asc, do: "↑", else: "↓"
  #   else
  #     ""
  #   end
  # end




end

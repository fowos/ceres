defmodule CeresWeb.Tags.TagsView do
  alias Ceres.Tags
  use CeresWeb, :live_view

  require Logger


  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    tags = Tags.list_tags_order_by_title_count()

    socket = socket
    |> stream(:tags, tags)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("delete-tag", %{"id" => id}, socket) do
    tag = Tags.get_tag!(id)

    case Tags.delete_tag(tag) do
      {:ok, tag} ->
        socket = socket
        |> stream_delete(:tags, tag)
        |> put_flash(:info, "Tag deleted successfully.")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error("Error while deleting tag. \n#{inspect(changeset)}")
        {:noreply, socket |> put_flash(:error, "Error while deleting tag. Please check server logs")}

    end
  end

  @impl Phoenix.LiveView
  def handle_event("rename-tag", %{"tag" => params}, socket) do
    IO.inspect(params, label: "params")

    case Tags.update_tag(Tags.get_tag!(params["id"]), params) do
      {:ok, tag} ->
        socket = socket
        |> put_flash(:info, "Tag renamed successfully.")
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error("Error while renaming tag. \n#{inspect(changeset)}")
        {:noreply, socket |> put_flash(:error, "Error while renaming tag. Please check server logs")}
    end
  end
end

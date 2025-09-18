defmodule CeresWeb.Chapters.ChaptersHome do
  alias Ceres.Storage.S3
  alias Ceres.Repo
  alias Ceres.Titles
  use CeresWeb, :live_view


  require Logger


  @impl Phoenix.LiveView
  def mount(%{"id" => id}, _session, socket) do
    socket = socket
    |> stream(:chapters, Titles.get_comics_chapters(id) |> Repo.preload(:pages))
    |> assign(:comic, Titles.get_comic!(id))

    {:ok, socket}
  end

  def handle_event("delete-chapter", %{"id" => id}, socket) do
    chapter = Titles.get_chapter!(id) |> Repo.preload(:pages)

    delete_s3 = chapter.pages
    |> delete_pages_files()

    del_pages_from_db = case delete_s3 do
      {:ok, deleted} ->
        deleted
      {:error, deleted} ->
        Logger.error("Error while deleting pages in s3, deleted not all files. \n#{inspect(deleted)}")
        deleted
    end
    |> delete_pages_database()

    case del_pages_from_db do
      :ok ->
        chapter = Titles.get_chapter!(id)
        Titles.delete_chapter(chapter)
        socket = socket
        |> stream_delete(:chapters, chapter)
        |> put_flash(:info, "Chapter deleted successfully.")
        {:noreply, socket}
      {:error, changeset} ->
        {:noreply, socket |> put_flash(:error, "Error while deleting chapter. #{inspect(changeset)}")}
    end


  end


  @doc """
  Delete files from s3
  """
  @spec delete_pages_files([Titles.Page.t()]) :: {:ok, [Titles.Page.t()]} | {:error, [Titles.Page.t()]}
  defp delete_pages_files([], deleted), do: {:ok, deleted}
  defp delete_pages_files([head | tail], deleted \\ []) do
    source = head.source
    [bucket, filepath] = String.split(source, ":")
    case S3.remove_from_s3(bucket, filepath) do
      :ok ->
        delete_pages_files(tail, [head | deleted])
      :error ->
        Logger.error("Error while deleting page file #{inspect(head)}")
        {:error, deleted}
    end
  end


  @doc """
  Delete pages from database
  """
  @spec delete_pages_database([Titles.Page.t()]) :: :ok | {:error, Ecto.Changeset.t()}
  defp delete_pages_database([]), do: :ok
  defp delete_pages_database([head | tail]) do
    case Titles.delete_page(head) do
      {:ok, page} ->
        delete_pages_database(tail)
      {:error, changeset} ->
        Logger.error("Error while deleting page #{inspect(head)}")
        {:error, changeset}
    end
  end
end

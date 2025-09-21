defmodule CeresWeb.Api.Titles.TitlesController do
  alias Ceres.Authors
  alias Ceres.Tags
  alias Ceres.Titles.Title
  alias Ceres.Repo
  alias Ceres.Titles
  alias Ecto

  require Logger

  import Ecto.Query

  use CeresWeb, :controller

  action_fallback CeresWeb.Api.FallbackController


  def show(conn, %{"name" => name}) do
    case Titles.get_title_by_name(name) do
      %Title{} = title ->
        render(conn, :show, title: title)
      other ->
        Logger.error("Error while getting title. Error: #{inspect(other)}")
        conn
        |> put_status(:not_found)
        |> json(%{error: "Title not found"})
    end
  end

  def create(conn, %{
    "name" => name,
    "type" => type,
    "tags" => tags,
    "authors" => authors,
    "publishers" => publishers
    }) do

      case Titles.create_title(%{original_name: String.trim(name), type: type}) do
        {:ok, %Title{} = title} ->
          myself = self()
          {pid, ref} = spawn_monitor(fn ->
            with :ok <- link_tags(title.id, tags),
            :ok <- link_authors(title.id, authors),
            :ok <- link_publishers(title.id, publishers)
            do
              send(myself, :ok)
            else
              {:error, error} ->
                send(myself, {:error, error})
              other ->
                send(myself, {:error, other})
            end
          end)

          receive do
            {:DOWN, ^ref, :process, ^pid, reason} ->
              Titles.delete_title(title)
              Logger.error("Error while creating title. \n#{inspect(reason)}")
              conn
              |> put_status(:bad_request)
              |> json(%{error: "Error while creating title. Check server logs, please."})

            {:error, error} ->
              Titles.delete_title(title)
              Logger.error("Error while creating title. \n#{inspect(error)}")
              conn
              |> put_status(:bad_request)
              |> json(%{error: error})

            :ok ->
              conn
              |> put_status(:created)
              |> render(:show, title: title)

          after
            5000 ->
              Process.demonitor(ref, [:flush])
              Process.exit(pid, :kill)

              Titles.delete_title(title)
              Logger.error("Error while creating title. Timeout reached. (5 seconds).")
              conn
              |> put_status(:server_error)
              |> json(%{error: "Server error, please try again later. For additional information check server logs."})
          end
        {:error, %Ecto.Changeset{} = error} ->
          Logger.error("Error while creating title, error: #{inspect(error)}")
          conn
          |> put_status(:bad_request)
          |> json(%{error: "Error while creating title. Check server logs, please."})
      end
  end

  defp link_tags(title_id, taglist) do
    has_error = Enum.map(taglist, fn tag ->
      Tags.create_titles_tags(%{title_id: title_id, tag_id: tag})
    end)
    |> Enum.any?(fn
      {:error, %Ecto.Changeset{}} -> true
      _ -> false
    end)

    if has_error do
      Logger.error("Error while connecting tags with title")
      {:error, "Error while connecting tags with title"}
    else
      :ok
    end
  end

  defp link_authors(title_id, authorlist) do
    has_error = Enum.map(authorlist, fn %{"id" => id, "role" => role} ->
      Authors.create_authors_titles(%{author_id: id, title_id: title_id, author_role: role})
    end)
    |> Enum.any?(fn
      {:error, %Ecto.Changeset{}} -> true
      _ -> false
    end)

    if has_error do
      Logger.error("Error while connecting authors with title")
      {:error, "Error while connecting authors with title"}
    else
      :ok
    end
  end

  defp link_publishers(title_id, publisherlist) do
    has_error = Enum.map(publisherlist, fn id ->
      Authors.create_publishers_titles(%{title_id: title_id, publisher_id: id})
    end)
    |> Enum.any?(fn el -> el == {:error, %Ecto.Changeset{}} end)

    if has_error do
      Logger.error("Error while connecting publishers with title")
      {:error, "Error while connecting publishers with title"}
    else
      :ok
    end
  end
end

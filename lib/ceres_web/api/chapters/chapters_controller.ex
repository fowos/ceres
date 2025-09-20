defmodule CeresWeb.Api.Chapters.ChaptersController do
  alias Ceres.Storage.S3
  alias Ceres.Titles.Page
  alias Ceres.Titles.Chapter
  alias Ceres.Storage.Converter
  alias Ceres.Titles.Title
  alias Ceres.Repo
  alias Ceres.Titles
  alias Ecto


  import Ecto.Query

  require Logger

  use CeresWeb, :controller

  action_fallback CeresWeb.Api.FallbackController

  @bucket "comics"


  def upload(conn, %{
    "file" => %Plug.Upload{} = upload,
    "volume" => volume,
    "number" => number,
    "comic_id" => comic_id
  }) do
    filepath = upload.path
    output_dir = Converter.generate_tmpdir()
    File.mkdir_p!(output_dir)

    result = case :zip.unzip(String.to_charlist(filepath), [{:cwd, String.to_charlist(output_dir)}]) do
      {:ok, _files} ->
        case Titles.create_chapter(%{volume: volume, number: number, comic_id: comic_id}) do
          {:ok, %Chapter{} = chapter} ->
            case save_pages(output_dir, chapter.id) do
              :ok ->
                {:ok, chapter}
              {:error, error} ->
                {:error, error}
            end
          {:error, changeset} ->
            Logger.error("Error while creating chapter.\n#{inspect(changeset)}")
            {:error, "Error creating chapter with current params, maybe it already exist. Check logs for more information"}
        end
      {:error, reason} ->
        Logger.error("Error while unzipping #{filepath}. Error: #{inspect(reason)}")
        {:error, reason}
    end

    File.rm_rf!(output_dir)


    case result do
      {:ok, chapter} ->
        render(conn, :show, chapter: chapter |> Repo.preload(:pages))
      {:error, error} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: error})
    end


  end

  defp save_pages(tmpdir, chapter_id) do
    list = Converter.files(tmpdir)
    |> Enum.map(fn {index, filepath} ->
      page_params = %{chapter_id: chapter_id, number: index, source: "#{@bucket}:#{chapter_id}/#{index}.jpeg"}

      case Titles.create_page(page_params) do
        {:ok, %Page{} = page} ->
          case S3.upload_to_s3(@bucket, filepath, "#{chapter_id}/#{index}.jpeg") do
            {:ok, _path} ->
              :ok

            {:error, error} ->
              Logger.error("Error while uploading #{filepath} to s3. Error: #{inspect(error)}")
              {:error, error}
          end

        {:error, changeset} ->
          Logger.error("Error while creating page.\n#{inspect(changeset)}")
          {:error, "Error creating page, #{inspect(changeset.errors)}. Please check server logs."}
      end
    end)

    case Enum.find(list, fn
       {:error, _} -> true
       _ -> false
      end) do
      {:error, error} -> {:error, error}
      nil -> :ok
    end
  end
end

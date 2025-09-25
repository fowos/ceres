defmodule CeresWeb.Api.Covers.CoversController do
  alias Ceres.Titles
  alias Ceres.Storage.S3
  alias Ceres.Storage.Converter
  use CeresWeb, :controller
  require Logger
  action_fallback CeresWeb.Api.FallbackController

  def upload(conn, %{
    "file" => %Plug.Upload{} = upload,
    "comic_id" => comic_id
  }) do
    # tmp = Converter.generate_tmpdir()
    # File.mkdir_p!(tmp)

    # filepath = Path.join(tmp, upload.filename)
    case save_cover(upload.path, comic_id) do
      :ok ->
        conn
        |> send_resp(201, "Cover uploaded successfully")
      {:error, error} ->
        Logger.error("Error while uploading cover. #{inspect(error)}")
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Error while uploading cover. #{inspect(error)}"})
    end
  end


  defp save_cover(filepath, comic_id) do
    case Titles.get_cover_by_comic_id(comic_id) do
      %Titles.Cover{} = cover -> Titles.delete_cover(cover)
      _ -> nil
    end

    case Titles.create_cover(%{source: "comics:#{comic_id}/cover.jpeg", comic_id: comic_id}) do
      {:ok, cover} ->
        case S3.upload_to_s3("comics", filepath, "#{comic_id}/cover.jpeg") do
          {:ok, _path} -> :ok
          {:error, error} -> {:error, error}
        end
      {:error, changeset} -> {:error, changeset}
    end
  end

end

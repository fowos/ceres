defmodule Ceres.Storage.S3 do
  require Logger
  alias ExAws
  alias ExAws.S3

  require Logger

  @doc """
  Upload image to s3

  Sends message to parent process:
  {:saved, ref}
  """
  def upload_image_to_s3(path, parent_pid, name, ref) do
    case S3.put_object("comics", name, File.read!(path)) |> ExAws.request do
      {:ok, _} ->
        send(parent_pid, {:saved, ref})
      {:error, error} ->
        Logger.error("Error while uploading #{path} to s3. Error: #{inspect(error)}")
        send(parent_pid, {:error, error})
    end

  end
end

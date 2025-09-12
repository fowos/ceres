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
  @spec upload_image_to_s3(String.t(), pid(), String.t(), reference()) :: :ok
  def upload_image_to_s3(path, parent_pid, name, ref) do
    case S3.put_object("comics", name, File.read!(path)) |> ExAws.request do
      {:ok, _} ->
        send(parent_pid, {:saved, ref})
      {:error, error} ->
        Logger.error("Error while uploading #{path} to s3. Error: #{inspect(error)}")
        send(parent_pid, {:error, error})
    end
    File.rm!(path)
  end

  @spec remove_image_from_s3(String.t()) :: :ok | :error
  def remove_image_from_s3("comics:" <> path) do
    IO.inspect(path, label: "path")

    case S3.delete_object("comics", path) |> ExAws.request do
      {:ok, _} ->
        Logger.debug("Removed #{"comics:" <> path} from s3")
        :ok
      {:error, error} ->
        Logger.error("Error while removing #{path} from s3. Error: #{inspect(error)}")
        :error
    end
  end
end

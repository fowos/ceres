defmodule Ceres.Storage.S3 do
  require Logger
  alias ExAws
  alias ExAws.S3

  require Logger

  @doc """
  Upload image to s3 in 'comics' bucket

  ## Examples

      iex> upload_to_s3("bucket", "path/to/file", "s3/path/to/file")
      {:ok, "bucket:s3/path/to/file"} | {:error, error}
  """
  @spec upload_to_s3(String.t(), String.t(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def upload_to_s3(bucket, filepath, s3_dest) do
    case S3.put_object(bucket, s3_dest, File.read!(filepath)) |> ExAws.request do
      {:ok, _} ->
        Logger.debug("Uploaded #{filepath} to s3 [#{bucket}] as #{s3_dest}")
        {:ok, "#{bucket}:#{s3_dest}"}
      {:error, error} ->
        Logger.error("Error while uploading #{filepath} to s3. Error: #{inspect(error)}")
        {:error, error}
    end
  end

  @doc """
  Remove image from s3

  ## Examples

      iex> remove_from_s3("comics", "s3/path/to/file")
      :ok | :error
  """
  @spec remove_from_s3(String.t(), String.t()) :: :ok | :error
  def remove_from_s3(bucket, s3_path) do
    case S3.delete_object(bucket, s3_path) |> ExAws.request do
      {:ok, _} ->
        Logger.debug("Removed #{s3_path} from s3")
        :ok
      {:error, error} ->
        Logger.error("Error while removing #{s3_path} from s3. Error: #{inspect(error)}")
        :error
    end
  end
end

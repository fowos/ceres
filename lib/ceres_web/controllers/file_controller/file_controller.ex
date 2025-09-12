defmodule CeresWeb.FileController.FileController do
  @moduledoc """
  This module contains functions for downloading images from S3 storage.
  """
  use CeresWeb, :controller

  alias ExAws.S3

  @bucket "comics"

  @doc """
  Download image from S3 storage
  """
  def download(conn, %{"key" => key_parts}) do
    key = Enum.join(key_parts, "/")

    stream = S3.get_object(@bucket, key)
    |> ExAws.request!()
    |> Map.fetch!(:body)

    conn
    |> put_resp_header("content-type", "image/avif")
    |> put_resp_header("content-disposition", ~s[attachment; filename="#{Path.basename(key)}"])
    |> send_resp(200, stream)
  end
end

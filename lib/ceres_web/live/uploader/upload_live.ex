defmodule CeresWeb.Uploader.UploadLive do
  use CeresWeb, :live_view


  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("upload", %{"file" => file}, socket) do
    # Handle file upload logic here
    {:noreply, socket}
  end

end

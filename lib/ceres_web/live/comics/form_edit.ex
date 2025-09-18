defmodule CeresWeb.Comics.FormEdit do
  require Logger
  alias Ceres.Storage.S3
  alias Ceres.Storage.Converter
  alias Mix.Local
  alias Ceres.Repo
  alias Ceres.Localizers
  alias Ceres.Titles.Comic
  alias Ceres.Titles
  use CeresWeb, :live_view

  @language_options [{"English", :en}, {"Japanese", :jp}, {"Korean", :kr}, {"Chinese", :cn}, {"Russian", :ru}]


  @impl true
  def mount(%{"id" => id}, _session, socket) do
    comic = Titles.get_comic!(id)

    localizers = comic
    |> Repo.preload(:localizers)
    |> Map.get(:localizers)

    socket = socket
    |> assign(:comic, comic)
    |> assign(:form, Titles.change_comic(comic) |> to_form)
    |> assign(:language_options, @language_options)
    |> assign(:localizers_search, nil)
    |> assign(:localizers_results, [])
    |> assign(:localizers, localizers)

    {:ok, socket}
  end

  ### Comic form

  @impl Phoenix.LiveView
  def handle_event("validate", %{"comic" => params}, socket) do
    changeset =
      Titles.change_comic(socket.assigns.comic, params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(:form, to_form(changeset))}
  end

  @impl Phoenix.LiveView
  def handle_event("save", %{"comic" => params}, socket) do
    case Titles.update_comic(socket.assigns.comic, params) do
      {:ok, comic} ->
        {:noreply, redirect(socket, to: "/comics")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(:form, to_form(changeset))}
    end
  end

  # Cover form

  # @impl Phoenix.LiveView
  # def handle_event("validate-cover", _params, socket) do
  #   {:noreply, socket}
  # end

  # @impl Phoenix.LiveView
  # def handle_event("submit-cover", params, socket) do
  #   IO.inspect(params, label: "params")

  #   path = consume_uploaded_entries(socket, :cover, fn %{path: path}, entry ->
  #     dest = upload_tmpdir()
  #     File.mkdir_p!(dest)

  #     IO.inspect(dest, label: "dest") # TODO

  #     destpath = Path.join(dest, entry.client_name)

  #     File.cp!(path, destpath)

  #     save_cover(destpath, socket.assigns.comic.id)
  #     {:ok, destpath}
  #   end)


  #   {:noreply, socket}
  # end

  # defp save_cover(filepath, comic_id) do
  #   pid = self()
  #   Task.start(fn ->
  #     basedir = Path.dirname(filepath)

  #     converted = Converter.get_files(basedir)
  #     |> sendfiles(pid)
  #     |> Converter.convert_files_to_avif(pid)

  #     if Enum.any?(converted, fn {status, _ref, _index, _path} -> status == :error end) do
  #       send(pid, {:error, "Error while converting images. Directory will be removed."})
  #       Logger.error("Error while converting images. Directory #{basedir} will be removed.")
  #       File.rm_rf!(basedir)
  #     end

  #     case converted
  #     |> List.first()
  #     |> save_cover_to_s3("comics", comic_id) do
  #       {:ok, source} ->
  #         send(pid, {:ok, source})
  #       {:error, error} ->
  #         Logger.error("Error while saving cover. Error: #{inspect(error)}")
  #         send(pid, {:error, error})
  #     end
  #   end)
  # end

  # @spec sendfiles([{reference(), String.t(), integer(), integer()}], pid()) :: any()
  # defp sendfiles(files, pid) do
  #   send(pid, {:started, files})
  #   files
  # end

  # defp save_cover_to_s3({:ok, ref, index, file}, bucket, comic_id) do
  #   s3_dest = "#{comic_id}/cover.avif"
  #   case Titles.create_cover(%{source: bucket <> s3_dest, comic_id: comic_id}) do
  #     {:ok, cover} ->
  #       case S3.upload_to_s3(bucket, file, s3_dest) do
  #         {:ok, source} ->
  #           Logger.debug("Uploaded #{file} to s3 [#{bucket}] as #{s3_dest}")
  #           {:ok, source}
  #         {:error, error} ->
  #           Logger.error("Error while uploading #{file} to s3. Error: #{inspect(error)}")
  #           {:error, error}
  #       end
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       Logger.error("Error while saving cover #{inspect(changeset)}")
  #       {:error, changeset}
  #   end
  # end


  # def handle_info({:started, files}, socket) do
  #   socket = socket
  #   |> assign(:upload_status, :converting)

  #   {:noreply, socket}
  # end

  # def handle_info({:converted, {ref, size}}, socket) do
  #   socket = socket
  #   |> assign(:upload_status, :uploading)

  #   {:noreply, socket}
  # end

  # def handle_info({:ok, _source}, socket) do
  #   socket = socket
  #   |> assign(:upload_status, :ok)

  #   {:noreply, socket}
  # end


  # def handle_info({:error, error}, socket) do
  #   socket = socket
  #   |> assign(:upload_status, :error)
  #   |> put_flash(:error, "Error while saving cover. Please check server logs.")

  #   {:noreply, socket}
  # end



  ### Localizer search form

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    case search do
      "" -> {:noreply, socket}
      search ->
        socket = socket
        |> assign(:localizers_results, Localizers.get_localizers_by_part_name(search))

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("select-localizer", %{"id" => id}, socket) do
    localizer = Localizers.get_localizer!(id)

    case Enum.any?(socket.assigns.localizers, fn x -> x.id == localizer.id end) do
      true -> {:noreply, socket}
      false ->
        case Localizers.create_localizers_comics(%{localizer_id: localizer.id, comic_id: socket.assigns.comic.id}) do
          {:ok, localizer_comics} ->
            socket = socket
            |> assign(:localizers, socket.assigns.localizers ++ [localizer])
            |> assign(:localizers_results, [])

            {:noreply, socket}

          {:error, %Ecto.Changeset{} = changeset} ->
            Logger.error("Error adding localizer. \n #{inspect(changeset)}")
            {:noreply, socket |> put_flash(:error, "Error adding localizer, please check server logs")}
        end
    end
  end

  @impl true
  def handle_event("remove-localizer", %{"id" => id}, socket) do
    case Enum.any?(socket.assigns.localizers, fn x -> x.id == id end) do
      true ->
        case Localizers.delete_localizers_comics_by_attrs(id, socket.assigns.comic.id) do
          {1, _} ->
            localizers = socket.assigns.localizers
            |> Enum.reject(fn x -> x.id == id end)

            socket = socket
            |> put_flash(:info, "Localizer removed successfully")
            |> assign(:localizers, localizers)
            {:noreply, socket}
        end
    end
  end

end

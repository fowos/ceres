defmodule CeresWeb.Chapters.ChaptersNew do
alias Ceres.Titles.Page
alias Ceres.Storage.S3
alias Ceres.Storage.Converter
  use CeresWeb, :live_view

  alias Ceres.Titles.Chapter
  alias Ceres.Titles

  require Logger

  @impl Phoenix.LiveView
  def mount(%{"id" => id}, _session, socket) do
    comic = Titles.get_comic!(id)

    socket = socket
    |> assign(:comic, comic)
    |> assign(:chapter, %Chapter{comic_id: comic.id})
    |> assign(:form, Titles.change_chapter(%Chapter{}) |> to_form)
    |> assign(:pages, [])
    |> allow_upload(:chapter_zip, accept: ~w(.zip), max_entries: 1, max_file_size: 50_000_000)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"chapter" => chapter_params}, socket) do
    IO.inspect(chapter_params, label: "chapter params")

    changeset =
      Titles.change_chapter(socket.assigns.chapter, chapter_params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(:form, to_form(changeset))}
  end

  @impl Phoenix.LiveView
  def handle_event("save", %{"chapter" => chapter_params}, socket) do
    chapter = %{
      comic_id: socket.assigns.comic.id,
      volume: String.to_integer(chapter_params["volume"]),
      number: String.to_integer(chapter_params["number"])
    }

    with {:ok, %Chapter{} = chapter} <- Titles.create_chapter(chapter) |> IO.inspect(label: "chapter"),
        {:ok, tmpdir} <- parse_zip_chapter(socket, chapter)
      do
        convert_images(tmpdir, chapter.id)  # TODO

        {:noreply, socket |> assign(:created_chapter_id, chapter.id)}
      else
        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, socket |> assign(:form, to_form(changeset))}
        other ->
          {:noreply, socket |> put_flash(:error, "Error while creating chapter. #{inspect(other)}")}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("validate-upload", _params, socket) do
    {:noreply, socket}
  end

  defp parse_zip_chapter(socket, %Chapter{} = chapter) do
    path = consume_uploaded_entries(socket, :chapter_zip, fn %{path: path}, _entry ->
      tmpdir = upload_tmpdir()

      dest = String.to_charlist(tmpdir)

      with {:ok, binary} <- File.read(path),
           {:ok, _files} <- :zip.unzip(binary, [{:cwd, dest}])
      do

        {:ok, tmpdir}
      else
        other ->
          raise "Error while unzipping chapter. \n#{inspect(other)}"
      end
    end)

    if Enum.count(path) == 1 do
      {:ok, List.first(path)}
    else
      {:ok, path}
    end
  end

  defp convert_images(basedir, chapter_id) do
    pid = self()
    Task.start(fn ->
      converted_files = Converter.get_files(basedir)
      |> IO.inspect(label: "files")
      |> sendfiles(pid)
      |> Converter.convert_files_to_avif(pid)

      if Enum.any?(converted_files, fn {status, _ref, _index, _path} -> status == :error end) do
        send(pid, {:error, "Error while converting images. Directory will be removed."})
        Logger.error("Error while converting images. Directory #{basedir} will be removed.")
        File.rm_rf!(basedir)
      end

      converted_files
      |> save_pages(chapter_id, pid)

      File.rm_rf!(basedir)
    end)
  end

  @doc """
  Just send file list in view process
  """
  @spec sendfiles([{reference(), String.t(), integer()}], pid()) :: any()
  defp sendfiles(files, pid) do
    send(pid, {:started, files})
    files
  end


  defp save_pages(converted_files, chapter_id, view_pid) do
    for {status, ref, index, path} <- converted_files do
      if status != :ok, do: raise "Error, status is #{status}"

      s3_dest = "#{chapter_id}/#{index}.avif"

      case Titles.create_page(%{chapter_id: chapter_id, number: index, source: s3_dest}) do
        {:ok, %Page{} = page} ->
          S3.upload_to_s3(path, s3_dest)
          send(view_pid, {:saved, ref})

        other -> raise "Error while creating page. #{inspect(other)}"
      end
    end
  end

  @doc """
  Generate path to basedir for uploaded images
  """
  defp upload_tmpdir, do: "#{System.tmp_dir!}/#{generate_id()}"


  defp generate_id(length \\ 24) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
    |> String.replace(~r/[-_]/, "")
    |> String.slice(0, length)
  end

  @impl Phoenix.LiveView
  def handle_info({:started, files}, socket) do
    pages = Enum.map(files, fn {ref, path, size, index} ->
      %{id: :erlang.ref_to_list(ref), path: path, size: format_bytes(size), new_size: nil, is_converted: false, s3: false}
    end)

    socket = socket
    |> assign(:pages, pages)


    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({:error, error}, socket) do
    Titles.get_chapter!(socket.assigns.created_chapter_id)
    |> Titles.delete_chapter()

    {:noreply, socket |> put_flash(:error, "Error while creating chapter. \n#{inspect(error)}")}
  end

  @doc """
  Handle info from convert_to_avif
  """
  @impl Phoenix.LiveView
  def handle_info({:converted, {ref, size}}, socket) do
    pages = socket.assigns.pages
    page = Enum.find(pages, fn p -> p.id == :erlang.ref_to_list(ref) end)

    socket = socket
    |> assign(:pages, List.replace_at(pages, pages |> Enum.find_index(fn p -> p.id == :erlang.ref_to_list(ref) end), %{page | new_size: format_bytes(size), is_converted: true}))

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({:saved, ref}, socket) do
    pages = socket.assigns.pages

    page = Enum.find(pages, fn p -> p.id == :erlang.ref_to_list(ref) end)

    socket = socket
    |> assign(:pages, List.replace_at(pages, pages |> Enum.find_index(fn p -> p.id == :erlang.ref_to_list(ref) end), %{page | s3: true}))

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({:finished}, socket) do
    socket = socket
    |> put_flash(:info, "Chapter created successfully")

    {:noreply, socket}
  end




  @units ["B", "KB", "MB", "GB", "TB", "PB"]

  def format_bytes(bytes) when is_integer(bytes) and bytes >= 0 do
    format(bytes, 0)
  end

  defp format(bytes, unit_index) when bytes < 1024 or unit_index == length(@units) - 1 do
    "#{round(bytes)} #{@units |> Enum.at(unit_index)}"
  end

  defp format(bytes, unit_index) do
    format(bytes / 1024, unit_index + 1)
  end
end

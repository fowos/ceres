defmodule Ceres.Storage.Converter do
  alias Ceres.Titles
  alias Ceres.Storage.S3

  require Logger

  def files(dirpath) do
    File.ls!(dirpath)
    |> Enum.map(fn file ->
      path = Path.join(dirpath, file)

      if not File.regular?(path), do: raise "File #{path} is not regular"
      if Path.extname(path) not in [".jpg", ".jpeg"], do: raise "File #{path} is not jpg/jpeg"

      {index, _other} = Integer.parse(Path.basename(file))
      {index, path}
    end)
  end




  def generate_tmpdir, do: "#{System.tmp_dir!}/#{generate_id()}"

  def generate_id(length \\ 16) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
    |> String.replace(~r/[-_]/, "")
    |> String.slice(0, length)
  end

  # defp response(data, pid \\ nil) do
  #   if pid, do: send(pid, data)
  # end
end

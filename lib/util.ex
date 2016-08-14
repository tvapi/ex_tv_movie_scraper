defmodule Util do
  def fetch_ids(path, kind) do
    path
    |> File.ls!
    |> Enum.map(fn(x) ->
         path <> "/" <> x
         |> read_json
         |> parse_json
         |> Tuple.to_list
         |> List.last
         |> Enum.map(fn(y) ->
              y[kind]["ids"]["trakt"]
            end)
       end)
    |> List.flatten
    |> Enum.sort
  end

  def read_json(path) do
    {:ok, data} =
      path
      |> File.read

    data
  end

  def parse_json(str) do
    str |> JSON.decode
  end

  def open_file(path) do
    path |> Path.dirname |> File.mkdir_p
    {:ok, file} = path |> File.open([:write])
    file
  end

  def write_file(file, body) do
    IO.binwrite(file, body)
    file
  end

  def close_file(file) do
    File.close(file)
  end
end

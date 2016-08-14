defmodule Mix.Tasks.TvmazeDownloadShowCast do
  use Mix.Task

  @shortdoc "tvmaze.com - Download show cast"

  def run(args) do
    Exq.start_link

    "data/tvmaze/updates.json"
    |> Util.read_json
    |> Util.parse_json
    |> Tuple.to_list
    |> List.last
    |> Enum.map(fn {id, timestamp} ->
         Exq.enqueue(Exq, "default", "Workers.TvmazeDownloadShowCastWorker", [id])
       end)
  end
end

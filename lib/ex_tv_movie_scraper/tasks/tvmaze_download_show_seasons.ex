defmodule Mix.Tasks.TvmazeDownloadShowSeasons do
  use Mix.Task

  @shortdoc "tvmaze.com - Download show seasons"

  def run(args) do
    Exq.start_link

    "data/tvmaze/updates.json"
    |> Util.read_json
    |> Util.parse_json
    |> Tuple.to_list
    |> List.last
    |> Enum.map(fn {id, timestamp} ->
         Exq.enqueue(Exq, "default", "Workers.TvmazeDownloadShowSeasonsWorker", [id])
       end)
  end
end

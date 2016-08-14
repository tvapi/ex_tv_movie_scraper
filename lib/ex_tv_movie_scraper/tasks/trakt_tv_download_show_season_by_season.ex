defmodule Mix.Tasks.TraktTvDownloadShowSeasonBySeason do
  use Mix.Task

  @shortdoc "trakt.tv - Download show season by season (useful when you receive timeout for all seasons in one request)"

  def run(args) do
    Exq.start_link

    "data/trakt_tv/shows/details"
    |> File.ls!
    |> Enum.each(fn(x) ->
         "data/trakt_tv/shows/details/" <> x <> "/seasons.json"
         |> Util.read_json
         |> Util.parse_json
         |> Tuple.to_list
         |> List.last
         |> Enum.each(fn(y) ->
              id = x |> String.replace("show_", "")
              number = y["number"] |> Integer.to_string
              Exq.enqueue(Exq, "default", "Workers.TraktTvDownloadShowSeasonBySeasonWorker", [id, number])
            end)
       end)
  end
end

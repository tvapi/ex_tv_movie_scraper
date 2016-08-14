defmodule Mix.Tasks.TraktTvDownloadShowSeasons do
  use Mix.Task

  @shortdoc "trakt.tv - Download show seasons"

  def run(args) do
    Exq.start_link

    Util.fetch_ids("./data/trakt_tv/shows/updates", "show")
    |> Enum.each(fn(x) ->
         id = Integer.to_string(x, 10)
         Exq.enqueue(Exq, "default", "Workers.TraktTvDownloadShowSeasonsWorker", [id])
       end)
  end
end

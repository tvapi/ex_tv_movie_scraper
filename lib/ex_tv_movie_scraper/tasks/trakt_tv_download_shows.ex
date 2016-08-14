defmodule Mix.Tasks.TraktTvDownloadShows do
  use Mix.Task

  @shortdoc "trakt.tv - Download shows"

  def run(args) do
    Exq.start_link

    Util.fetch_ids("./data/trakt_tv/shows/updates", "show")
    |> Enum.each(fn(x) ->
         id = Integer.to_string(x, 10)
         Exq.enqueue(Exq, "default", "Workers.TraktTvDownloadShowsWorker", [id])
       end)
  end
end

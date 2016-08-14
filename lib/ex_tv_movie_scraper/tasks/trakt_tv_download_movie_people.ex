defmodule Mix.Tasks.TraktTvDownloadMoviePeople do
  use Mix.Task

  @shortdoc "trakt.tv - Download movie people"

  def run(args) do
    Exq.start_link

    Util.fetch_ids("./data/trakt_tv/movies/updates", "movie")
    |> Enum.each(fn(x) ->
         id = Integer.to_string(x, 10)
         Exq.enqueue(Exq, "default", "Workers.TraktTvDownloadMoviePeopleWorker", [id])
       end)
  end
end

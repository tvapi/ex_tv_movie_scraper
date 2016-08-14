defmodule Mix.Tasks.TraktTvDownloadUpdates do
  use Mix.Task

  @shortdoc "trakt.tv - Download show updates"

  def run(args) do
    HTTPoison.start
    Exq.start_link
    add_jobs_to_queue("shows")
    add_jobs_to_queue("movies")
  end

  defp add_jobs_to_queue(kind) do
    1..total_pages(kind)
    |> Enum.to_list
    |> Enum.each(fn(x) ->
         num = x |> Integer.to_string(10)
         Exq.enqueue(Exq, "default", "Workers.TraktTvDownloadUpdatesWorker", [kind, num])
       end)
  end

  defp total_pages(kind) do
    count(kind) / 10 |> Float.ceil |> round
  end

  defp count(kind) do
    output = HTTPoison.get!("https://api.trakt.tv/" <> kind <> "/updates/1900-01-01?limit=1", ["Content-Type": "application/json", "trakt-api-version": 2, "trakt-api-key": Application.get_env(:trakt_tv, :client_id)])
    el = output.headers
    |> Enum.filter(fn(x) ->
         x |> Tuple.to_list |> List.first == "X-Pagination-Item-Count"
       end)
    el |> List.first |> Tuple.to_list |> List.last |> String.to_integer
  end
end

defmodule Workers.TraktTvDownloadShowSeasonBySeasonWorker do
  def perform(id, num) do
    HTTPoison.start

    response = HTTPoison.get!("https://api.trakt.tv/shows/" <> id <> "/seasons/" <> num <> "?extended=full,images,episodes", ["Content-Type": "application/json", "trakt-api-version": 2, "trakt-api-key": Application.get_env(:trakt_tv, :client_id)])
    "shows/details/show_" <> id <> "/seasons_" <> num <> ".json"
    |> open_file
    |> write_file(response.body)
    |> close_file
  end

  defp open_file(path) do
    filename = "data/trakt_tv/" <> path
    filename |> Path.dirname |> File.mkdir_p
    {:ok, file} = filename |> File.open([:write])
    file
  end

  defp write_file(file, body) do
    IO.binwrite(file, body)
    file
  end

  defp close_file(file) do
    File.close(file)
  end
end

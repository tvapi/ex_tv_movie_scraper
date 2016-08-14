defmodule Workers.TraktTvDownloadUpdatesWorker do
  def perform(kind, page) do
    HTTPoison.start

    response = HTTPoison.get!("https://api.trakt.tv/" <> kind <> "/updates/1990-01-01?page=" <> page, ["Content-Type": "application/json", "trakt-api-version": 2, "trakt-api-key": Application.get_env(:trakt_tv, :client_id)])
    {:ok, parsed_json} = Util.parse_json(response.body)

    "data/trakt_tv/" <> kind <> "/updates/updates_" <> page <> ".json"
    |> Util.open_file
    |> Util.write_file(response.body)
    |> Util.close_file
  end
end

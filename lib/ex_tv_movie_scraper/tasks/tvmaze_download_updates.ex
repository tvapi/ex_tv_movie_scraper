defmodule Mix.Tasks.TvmazeDownloadUpdates do
  use Mix.Task

  @shortdoc "tvmaze.com - Download show updates"

  def run(args) do
    HTTPoison.start

    response = HTTPoison.get!("http://api.tvmaze.com/updates/shows")
    {:ok, parsed_json} = Util.parse_json(response.body)

    "data/tvmaze/updates.json"
    |> Util.open_file
    |> Util.write_file(response.body)
    |> Util.close_file
  end
end

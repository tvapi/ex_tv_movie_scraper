defmodule Workers.TvmazeDownloadShowsWorker do
  def perform(id) do
    HTTPoison.start

    response = HTTPoison.get!("http://api.tvmaze.com/shows/" <> id <> "?embed[]=cast&embed[]=episodes")
    {:ok, parsed_json} = Util.parse_json(response.body)

    "data/tvmaze/shows/details/show_" <> id <> "/summary.json"
    |> Util.open_file
    |> Util.write_file(response.body)
    |> Util.close_file
  end
end

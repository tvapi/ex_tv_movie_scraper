defmodule Workers.ThetvdbDownloadFullSeriesWorker do
  def perform(series_id) do
    HTTPoison.start

    response = series_id |> url |> HTTPoison.get!

    "full_series/" <> Integer.to_string(series_id) <> ".xml"
    |> open_file
    |> write_file(response.body)
    |> close_file
  end

  defp url(series_id) do
    "http://thetvdb.com/api/" <>
    Application.get_env(:thetvdb, :api_key) <>
    "/series/" <>
    Integer.to_string(series_id) <>
    "/all/en.xml"
  end

  defp open_file(path) do
    filename = "data/thetvdb/" <> path
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

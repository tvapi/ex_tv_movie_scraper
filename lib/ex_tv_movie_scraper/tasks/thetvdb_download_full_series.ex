defmodule Mix.Tasks.ThetvdbDownloadFullSeries do
  use Mix.Task

  @shortdoc "thetvdb.com - Download Full Series"

  def run(args) do
    data = args |> List.first |> normalize_update_kind |> read_json |> parse_json

    Exq.start_link
    data["series"]
    |> Enum.each(fn(x) ->
         Exq.enqueue(Exq, "default", "Workers.ThetvdbDownloadFullSeriesWorker", [x["id"]])
         Exq.enqueue(Exq, "default", "Workers.ThetvdbDownloadActorsWorker", [x["id"]])
         Exq.enqueue(Exq, "default", "Workers.ThetvdbDownloadBannersWorker", [x["id"]])
       end)
  end

  defp normalize_update_kind(kind) do
    case kind do
      "day" -> "day"
      "week" -> "week"
      "month" -> "month"
      "all" -> "all"
      nil -> "day"
      _ -> "day"
    end
  end

  defp read_json(kind) do
    {:ok, data} =
      kind
      |> json_filename
      |> File.read

    data
  end

  defp parse_json(data) do
    {:ok, parsed_data} = data |> JSON.decode

    parsed_data
  end

  defp json_filename(kind) do
    "data/thetvdb/updates/updates_" <> kind <> ".json"
  end
end

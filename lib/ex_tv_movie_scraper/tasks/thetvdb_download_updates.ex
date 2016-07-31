defmodule Mix.Tasks.ThetvdbDownloadUpdates do
  use Mix.Task
  import SweetXml

  @shortdoc "thetvdb.com - Download updates"

  def run(args) do
    kind = args |> List.first |> normalize_update_kind

    HTTPoison.start
    response = kind |> url |> HTTPoison.get!
    save_xml(kind, response)
    save_json(kind, response)
  end

  defp save_xml(kind, response) do
    kind
    |> filename
    |> open_file
    |> write_file(response.body)
    |> close_file
  end

  defp save_json(kind, response) do
    {xml_doc, []} = response.body |> String.to_char_list |> :xmerl_scan.string
    {:ok, json_text} = xml_doc |> parse_doc |> JSON.encode

    kind
    |> json_filename
    |> open_file
    |> write_file(json_text)
    |> close_file
  end

  defp open_file(path) do
    filename = "data/thetvdb/updates/" <> path
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

  defp filename(kind) do
    "updates_" <> kind <> ".xml"
  end

  defp json_filename(kind) do
    "updates_" <> kind <> ".json"
  end

  defp url(kind) do
    "http://thetvdb.com/api/" <>
    Application.get_env(:thetvdb, :api_key) <>
    "/updates/" <>
    filename(kind)
  end

  defp parse_doc(doc) do
    doc
    |> xpath(
      ~x"//Data"e,
      time: ~x"./@time"i,
      series: [
        ~x"./Series"l,
        id: ~x"./id/text()"i,
        time: ~x"./time/text()"i
      ],
      episodes: [
        ~x"./Episode"l,
        id: ~x"./id/text()"i,
        series_id: ~x"./Series/text()"i,
        time: ~x"./time/text()"i
      ],
      banners: [
        ~x"./Banner"l,
        season_num: ~x"./SeasonNum/text()"s,
        series_id: ~x"./Series/text()"i,
        format: ~x"./format/text()"s,
        language: ~x"./language/text()"s,
        path: ~x"./path/text()"s,
        time: ~x"./time/text()"i,
        type: ~x"./type/text()"s,
      ]
    )
  end
end

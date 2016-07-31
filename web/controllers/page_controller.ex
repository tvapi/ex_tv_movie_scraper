defmodule ExTvMovieScraper.PageController do
  use ExTvMovieScraper.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

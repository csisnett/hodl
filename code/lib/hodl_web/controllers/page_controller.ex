defmodule HodlWeb.PageController do
  use HodlWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

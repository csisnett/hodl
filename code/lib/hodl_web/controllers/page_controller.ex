defmodule HodlWeb.PageController do
  use HodlWeb, :controller

  alias Hodl.Users.User

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def why(conn, _params) do
    render(conn, "why.html")
  end

  def plans(conn, _params) do
    render(conn, "plans.html")
  end

  def terms(conn, _params) do
    render(conn, "terms.html")
  end

  def privacy(conn, _params) do
    render(conn, "privacy.html")
  end

  def calculator(conn, _params) do
    render(conn, "calculator.html")
  end

  def random_username(conn, _params) do
    username = User.generate_random_combination()

    json(conn, %{"username" => username})
  end
end

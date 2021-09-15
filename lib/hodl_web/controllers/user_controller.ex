defmodule HodlWeb.UserController do
  use HodlWeb, :controller

  alias Hodl.Users.User
  alias Hodl.Accounts
  alias Hodl.Accounts.Setting

  def new_account(conn, _params) do
    render(conn, "new-account.html")
  end

  def create_account(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
      conn = HoldWeb.Pow.Plug.sign_in_user_from_server(conn, user)
      |> redirect(to: "/new-schedule")

      {:error, changeset} ->
        conn
        |> redirect(to: "/new-account?retry=true")
    end
  end

  def sign_out(conn, _params) do
    conn
    |> Plug.Conn.delete_resp_cookie("_hodl_key")
    |> Plug.Conn.delete_resp_cookie("hodl_persistent_session")
    |> redirect(to: "/session/new")
  end

end

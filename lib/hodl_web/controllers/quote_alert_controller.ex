defmodule HodlWeb.QuoteAlertController do
  use HodlWeb, :controller

  alias Hodl.Portfolio
  alias Hodl.Portfolio.QuoteAlert
  require Logger

  def index(conn, _params) do
    user = conn.assigns.current_user
    IO.inspect("#{user.id}")
    quotealerts = Portfolio.list_user_quotealerts_out(user)
    coins = Portfolio.make_coin_list(quotealerts, [])
    render(conn, "index.html", quotealerts: quotealerts, coins: coins)
  end

  def my_alerts(conn, _params) do
    user = conn.assigns.current_user
    quotealerts = Portfolio.list_user_quotealerts_out(user)
    json(conn, %{"quote_alerts" => quotealerts})
  end

  def new(conn, _params) do
    changeset = Portfolio.change_quote_alert(%QuoteAlert{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"quote_alert" => quote_alert_params}) do
    user = conn.assigns.current_user
    with {:ok, %QuoteAlert{} = quote_alert} <- Portfolio.create_quote_alert(quote_alert_params, user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.quote_alert_path(conn, :show, quote_alert))
      |> render("show.json", quote_alert: quote_alert)
    end
  end

  def show(conn, %{"uuid" => uuid}) do
    quote_alert = Portfolio.get_quote_alert_by_uuid(uuid)
    render(conn, "show.html", quote_alert: quote_alert)
  end

  def edit(conn, %{"uuid" => uuid}) do
    quote_alert = Portfolio.get_quote_alert_by_uuid(uuid)
    changeset = Portfolio.change_quote_alert(quote_alert)
    render(conn, "edit.html", quote_alert: quote_alert, changeset: changeset)
  end

  def update(conn, %{"uuid" => uuid, "quote_alert" => quote_alert_params}) do
    quote_alert = Portfolio.get_quote_alert_by_uuid(uuid)

    case Portfolio.update_quote_alert(quote_alert, quote_alert_params) do
      {:ok, quote_alert} -> 
        conn = conn |> put_flash(:info, "Alert modified successfully.")
        redirect(conn, to: "/alerts")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", quote_alert: quote_alert, changeset: changeset)
    end
  end

  def delete(conn, %{"uuid" => uuid}) do
    quote_alert = Portfolio.get_quote_alert_by_uuid(uuid)
    {:ok, _quote_alert} = Portfolio.soft_delete_quote_alert(quote_alert)

    conn
    |> put_flash(:info, "Alert deleted successfully.")
    |> redirect(to: Routes.quote_alert_path(conn, :index))
  end
end

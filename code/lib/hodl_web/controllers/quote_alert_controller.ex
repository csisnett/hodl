defmodule HodlWeb.QuoteAlertController do
  use HodlWeb, :controller

  alias Hodl.Portfolio
  alias Hodl.Portfolio.QuoteAlert

  def index(conn, _params) do
    quotealerts = Portfolio.list_quotealerts()
    render(conn, "index.html", quotealerts: quotealerts)
  end

  def new(conn, _params) do
    changeset = Portfolio.change_quote_alert(%QuoteAlert{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"quote_alert" => quote_alert_params}) do
    case Portfolio.create_quote_alert(quote_alert_params) do
      {:ok, quote_alert} ->
        conn
        |> put_flash(:info, "Quote alert created successfully.")
        |> redirect(to: Routes.quote_alert_path(conn, :show, quote_alert))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    quote_alert = Portfolio.get_quote_alert!(id)
    render(conn, "show.html", quote_alert: quote_alert)
  end

  def edit(conn, %{"id" => id}) do
    quote_alert = Portfolio.get_quote_alert!(id)
    changeset = Portfolio.change_quote_alert(quote_alert)
    render(conn, "edit.html", quote_alert: quote_alert, changeset: changeset)
  end

  def update(conn, %{"id" => id, "quote_alert" => quote_alert_params}) do
    quote_alert = Portfolio.get_quote_alert!(id)

    case Portfolio.update_quote_alert(quote_alert, quote_alert_params) do
      {:ok, quote_alert} ->
        conn
        |> put_flash(:info, "Quote alert updated successfully.")
        |> redirect(to: Routes.quote_alert_path(conn, :show, quote_alert))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", quote_alert: quote_alert, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    quote_alert = Portfolio.get_quote_alert!(id)
    {:ok, _quote_alert} = Portfolio.delete_quote_alert(quote_alert)

    conn
    |> put_flash(:info, "Quote alert deleted successfully.")
    |> redirect(to: Routes.quote_alert_path(conn, :index))
  end
end

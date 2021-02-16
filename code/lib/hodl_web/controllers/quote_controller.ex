defmodule HodlWeb.QuoteController do
  use HodlWeb, :controller

  alias Hodl.Portfolio
  alias Hodl.Portfolio.Quote

  action_fallback HodlWeb.FallbackController

  def index(conn, _params) do
    quotes = Portfolio.list_quotes()
    render(conn, "index.json", quotes: quotes)
  end

  def create(conn, %{"quote" => quote_params}) do
    with {:ok, %Quote{} = quote} <- Portfolio.create_quote(quote_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.quote_path(conn, :show, quote))
      |> render("show.json", quote: quote)
    end
  end

  def show(conn, %{"id" => id}) do
    quote = Portfolio.get_quote!(id)
    render(conn, "show.json", quote: quote)
  end

  def update(conn, %{"id" => id, "quote" => quote_params}) do
    quote = Portfolio.get_quote!(id)

    with {:ok, %Quote{} = quote} <- Portfolio.update_quote(quote, quote_params) do
      render(conn, "show.json", quote: quote)
    end
  end

  def delete(conn, %{"id" => id}) do
    quote = Portfolio.get_quote!(id)

    with {:ok, %Quote{}} <- Portfolio.delete_quote(quote) do
      send_resp(conn, :no_content, "")
    end
  end
end

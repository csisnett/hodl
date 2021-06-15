defmodule HodlWeb.QuoteAlertView do
  use HodlWeb, :view
  alias HodlWeb.QuoteAlertView

  def render("index.json", %{quote_alert: quote_alert}) do
    %{data: render_many(quote_alert, QuoteAlertView, "quote_alert.json")}
  end

  def render("show.json", %{quote_alert: quote_alert}) do
    %{data: render_one(quote_alert, QuoteAlertView, "quote_alert.json")}
  end

  def render("quote_alert.json", %{quote_alert: quote_alert}) do
    %{id: quote_alert.id,
      uuid: quote_alert.uuid,
      price_usd: quote_alert.price_usd}
  end

end

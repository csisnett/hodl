defmodule HodlWeb.QuoteAlertView do
  use HodlWeb, :view
  alias HodlWeb.QuoteAlertView

  def render("index.json", %{quote_alerts: quote_alerts}) do
    %{quote_alerts: render_many(quote_alerts, QuoteAlertView, "quote_alert.json")}
  end

  def render("show.json", %{quote_alert: quote_alert}) do
    render_one(quote_alert, QuoteAlertView, "quote_alert.json")
  end

  def render("quote_alert.json", %{quote_alert: quote_alert}) do
    %{uuid: quote_alert.uuid,
      price_usd: quote_alert.price_usd,
      uuid: quote_alert.uuid,
      coin_name: quote_alert.coin_name,
      coin_symbol: quote_alert.coin_symbol,
      comparator: quote_alert.comparator,
      active: quote_alert.active?}
  end

end

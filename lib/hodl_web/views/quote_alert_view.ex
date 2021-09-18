defmodule HodlWeb.QuoteAlertView do
  use HodlWeb, :view
  alias HodlWeb.QuoteAlertView

  def javascript_coins(coins) do
    Enum.map(coins, fn coin -> coin.uuid end)
    |> Enum.join(",")
  end

  def order_by_coin([], result) do
    result
  end

  def order_by_coin(quote_alerts, result) do
    [first | rest] = quote_alerts
    coin_uuid = first.coin_uuid
    alerts_for_coin = Enum.filter(quote_alerts, fn quote_alert -> quote_alert.coin_uuid == coin_uuid end)
    other_coin_alerts = Enum.filter(quote_alerts, fn quote_alert -> quote_alert.coin_uuid != coin_uuid end)
    order_by_coin(other_coin_alerts, result ++ [alerts_for_coin]) #Maintains a seperate list for each coin
  end

  def output_alerts([], result) do
    html_escape(result)
  end

  def coin_category([], result) do
    result
  end

  def single_alert_html(quote_alert, acc) do
    # Because we get the coin names and symbols from external sources we need to make sure
    # There's nothing in them that could be used for attacks
    with {:safe, coin_name} <- html_escape(quote_alert.coin_name),
         {:safe, coin_symbol} <- html_escape(quote_alert.coin_symbol)

    do
      coin_name_raw = {:safe, coin_name} |> safe_to_string()
      coin_symbol_raw = {:safe, coin_symbol} |> safe_to_string()
    alert_string = """
    <b-col cols="4">
    <alert
    coin_name="#{coin_name_raw}"
    coin_symbol="#{coin_symbol_raw}"
    uuid="#{quote_alert.uuid}"
    above_price="#{quote_alert.above_price}"
    below_price="#{quote_alert.below_price}"
    above_percentage="#{quote_alert.above_percentage}"
    below_percentage="#{quote_alert.below_percentage}"
    coin_uuid="#{quote_alert.coin.uuid}">

    </alert>
    </b-col>

    """
    alert_string <> acc
    else
        {:unsafe, _} -> acc
    end
  end

    # [QuoteAlert{coin_uuid: uuid}, QuoteAlert{coin_uuid: uuid}, ..] -> String
  # Receives a list of quote alerts with the same coin and outputs the String html for each alert
  def coin_category(quote_alerts, acc) do
    [first_alert | rest] = quote_alerts
    with {:safe, coin_name} <- html_escape(first_alert.coin_name)
    do
      coin_name_raw = {:safe, coin_name} |> safe_to_string()

    initial_coin_string = """

    <h3 style="text-align: center;"> #{coin_name_raw} alerts </h3>
    <b-container >
    <b-row style="min-width: 600px; position: relative;">
    """
    all_alerts_string = Enum.reduce(quote_alerts, "", &single_alert_html/2)
    ending_string = """

    </b-row>
    </b-container>
    <br>
    """

    initial_coin_string <> all_alerts_string <> ending_string <> acc
    else
      {:unsafe, _} -> "<h3> Error displaying coin #{first_alert.coin_uuid}, please notify the admin </h3>"
    end
  end

  def get_alerts() do
    [user | _] = Hodl.Repo.all(Hodl.Users.User)
    quotealerts = Hodl.Portfolio.list_user_quotealerts_out(user)
  end

  def output_alerts([]) do
    raw(" <br> <br> <h2> My alerts </h2> <br> <h4> You have no active alerts to show </h4>")
  end

  # [QuoteAlerts] -> HTML
  # Output the quote alerts categorized by coin
  def output_alerts(quote_alerts) do
    alerts_per_coin = order_by_coin(quote_alerts, [])
    all_alerts_string = Enum.reduce(alerts_per_coin, "", &coin_category/2)
    raw(all_alerts_string)
  end

  def render("index.json", %{quote_alerts: quote_alerts}) do
    %{quote_alerts: render_many(quote_alerts, QuoteAlertView, "quote_alert.json")}
  end

  def render("show.json", %{quote_alert: quote_alert}) do
    render_one(quote_alert, QuoteAlertView, "quote_alert.json")
  end

  def render("quote_alert.json", %{quote_alert: quote_alert}) do
    %{uuid: quote_alert.uuid,
      above_price: quote_alert.above_price,
      below_price: quote_alert.below_price,
      above_percentage: quote_alert.above_percentage,
      below_percentage: quote_alert.below_percentage,
      uuid: quote_alert.uuid,
      coin_name: quote_alert.coin_name,
      coin_symbol: quote_alert.coin_symbol,
      active: quote_alert.active}
  end

end

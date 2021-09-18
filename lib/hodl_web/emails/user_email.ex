defmodule HodlWeb.UserEmail do
    alias Hodl.Users.User
    alias Hodl.Portfolio
    alias Hodl.Portfolio.{QuoteAlert, Quote, AlertTrigger}
    use Phoenix.Swoosh, view: HodlWeb.EmailView, layout: {HodlWeb.LayoutView, :email}

    def welcome(user) do
      new()
      |> from("daniel@howtohodl.org")
      |> to(user.email)
      |> subject("Hello, Avengers!")
      |> render_body("welcome.html", %{username: user.email})
    end

    def alert(%User{} = user,%Quote{} = myquote, %QuoteAlert{} = quote_alert) do
    subject = Portfolio.quote_alert_subject(quote_alert)

    new()
    |> to({user.username, user.email})
    |> from("daniel@howtohodl.org")
    |> subject(subject)
    |> render_body("alert.html", %{trigger_time: myquote.inserted_at, trigger_price: myquote.price_usd, quote_alert: quote_alert})
    end

    def alert_trigger(%User{} = user,%AlertTrigger{} = alert_trigger) do

      message = Portfolio.trigger_message(alert_trigger)
      alert_trigger = alert_trigger |> Map.put(:message, message)

      new()
      |> to({user.username, user.email})
      |> from("daniel@howtohodl.org")
      |> subject(message)
      |> render_body("alert.html", %{trigger_time: alert_trigger.quote.inserted_at, trigger_price: alert_trigger.quote.price_usd, alert_trigger: alert_trigger})
      end

    def message_for_alert(%Quote{} = myquote, %QuoteAlert{} = quote_alert) do
      "message"
    end
end

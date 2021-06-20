defmodule HodlWeb.UserEmail do
    alias Hodl.Users.User
    alias Hodl.Portfolio.{QuoteAlert, Quote}
    use Phoenix.Swoosh, view: HodlWeb.EmailView, layout: {HodlWeb.LayoutView, :email}
  
    def welcome(user) do
      new()
      |> from("daniel@howtohodl.org")
      |> to(user.email)
      |> subject("Hello, Avengers!")
      |> render_body("welcome.html", %{username: user.email})
    end

    def alert(%User{} = user,%Quote{} = myquote, %QuoteAlert{} = quote_alert, subject) do
    new()
    |> to({user.username, user.email})
    |> from("daniel@howtohodl.org")
    |> subject(subject)
    |> render_body("alert.html", %{trigger_time: myquote.inserted_at, trigger_price: myquote.price_usd, quote_alert: quote_alert})
    end

    def message_for_alert(%Quote{} = myquote, %QuoteAlert{} = quote_alert) do
      "message"
    end
end
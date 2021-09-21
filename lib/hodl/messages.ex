defmodule Hodl.Messages do
  @moduledoc """
  The Portfolio context.
  """

  import Ecto.Query, warn: false
  alias Hodl.Repo
  alias Hodl.Portfolio
  alias Hodl.Accounts
  alias Hodl.Portfolio.{Coin, Coinrank, Cycle, Hodlschedule, Quote, Ranking, QuoteAlert, AlertTrigger}
  alias Hodl.Users.User


  def send_sms(%AlertTrigger{} = alert_trigger) do
    alert_trigger
  end

  def send_twilio_sms() do
    twilio_sid = Application.fetch_env!(:hodl, :twilio_account_sid)
    twilio_auth_token = Application.fetch_env!(:hodl, :twilio_auth_token)
    authorization = "#{twilio_sid}:#{twilio_auth_token}" |> Base.encode64()

    from_phone = "+19496474789"
    recipient_phone = "+50766725373"

    params = %{"To" => recipient_phone, "From" => from_phone, "Body" => "Hello%20there"} |> URI.encode_query()
    IO.puts(params)

    headers = [
        {"content-type", "application/x-www-form-urlencoded"},
        {"authorization", "Basic #{authorization}"}]

    request = %HTTPoison.Request{
      method: :post,
      url: "https://api.twilio.com/2010-04-01/Accounts/#{twilio_sid}/Messages.json?Body=Hi%20there%20again&From=%2B19496474789&To=%2B50766725373",
      headers: headers,
    }
    payload = "Body=Hi%20there%20again&From=%2B19496474789&To=%2B50766725373"
    #HTTPoison.request(request)
    Mojito.post("https://api.twilio.com/2010-04-01/Accounts/#{twilio_sid}/Messages.json", headers, payload)
  end

  # They asked for bank transfer :(
  def vonage_sms() do
    api_secret = "api_secret"
    api_key = "api_key"
    params = %{"to" => "+50766725373", "from" => "How to hodl", "text" => "a text message using the vonage SMS api", "api_key" => api_key, "api_secret" => api_secret} |> URI.encode_query()

    authorization = "#{api_key}:#{api_secret}" |> Base.encode64()
    headers = [
      {"content-type", "application/x-www-form-urlencoded"},
      {"authorization", "Basic #{authorization}"}]
      Mojito.post("https://rest.nexmo.com/sms/json", headers, params)
  end

  def message_bird_sms() do
    params = %{"body" => "first bird message", "recipients" => "+50766725373", "originator" => "How to hodl"} |> URI.encode_query()
    api_secret = "api_secret"

    headers = [
      {"content-type", "application/x-www-form-urlencoded"},
      {"authorization", "AccessKey #{api_secret}"}]
      Mojito.post("https://rest.messagebird.com/messages", headers, params)
  end

end

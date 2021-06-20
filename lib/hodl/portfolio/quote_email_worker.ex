defmodule Hodl.Portfolio.QuoteEmailWorker do
    alias Hodl.Portfolio
    use Oban.Worker, queue: :emails, max_attempts: 9
  
    @impl Oban.Worker
    def perform(%Oban.Job{args: %{"id" => id} = args}) do
      quote_alert = Portfolio.get_quote_alert!(id)

      status = Portfolio.send_quote_alert_email(quote_alert)
      utc_now = DateTime.utc_now()
      case status do
        :ok -> Portfolio.update_quote_alert(quote_alert, %{"email_sent_datetime" => utc_now})
        _ -> {:error, :error_sending_the_email_for_alert}
      end
    end
  end
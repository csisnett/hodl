defmodule Hodl.Portfolio.TriggerEmailWorker do
  alias Hodl.Portfolio
  use Oban.Worker, queue: :emails, max_attempts: 9

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id} = args}) do
    alert_trigger = Portfolio.get_alert_trigger_loaded!(id)

    status = Portfolio.send_alert_trigger_email(alert_trigger)
    utc_now = DateTime.utc_now()
    case status do
      :ok ->
        Portfolio.update_alert_trigger(alert_trigger, %{"email_sent_datetime" => utc_now})
        Portfolio.update_quote_alert_active(alert_trigger.quote_alert, alert_trigger.type)

      _ -> {:error, :error_sending_the_email_for_alert}
    end
  end
end

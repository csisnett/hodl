defmodule Hodl.Portfolio.TriggerEmailWorker do
  alias Hodl.Portfolio
  alias Hodl.Repo

  use Oban.Worker, queue: :emails, max_attempts: 9

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id} = args}) do
    alert_trigger = Portfolio.get_alert_trigger_loaded!(id)
    utc_now = DateTime.utc_now()

    status = Portfolio.send_alert_trigger_email(alert_trigger)
    {:ok, sms_status} = Portfolio.send_alert_trigger_text_message(alert_trigger)

    sms_sent_datetime = if sms_status == :not_a_text_alert do nil else utc_now end

    case status do
      :ok ->
        Repo.transaction(fn ->
        Portfolio.update_alert_trigger(alert_trigger, %{"email_sent_datetime" => utc_now, "sms_sent_datetime" => sms_sent_datetime})
        Portfolio.update_quote_alert_active(alert_trigger.quote_alert, alert_trigger.type)
        end)

      _ -> {:error, :error_sending_the_email_for_alert}
    end
  end
end

defmodule HodlWeb.AlertTriggerController do
  use HodlWeb, :controller

  alias Hodl.Portfolio
  alias Hodl.Portfolio.AlertTrigger

  action_fallback HodlWeb.FallbackController

  def index(conn, _params) do
    alerttriggers = Portfolio.list_alerttriggers()
    render(conn, "index.json", alerttriggers: alerttriggers)
  end

  def create(conn, %{"alert_trigger" => alert_trigger_params}) do
    with {:ok, %AlertTrigger{} = alert_trigger} <- Portfolio.create_alert_trigger(alert_trigger_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.alert_trigger_path(conn, :show, alert_trigger))
      |> render("show.json", alert_trigger: alert_trigger)
    end
  end

  def show(conn, %{"id" => id}) do
    alert_trigger = Portfolio.get_alert_trigger!(id)
    render(conn, "show.json", alert_trigger: alert_trigger)
  end

  def update(conn, %{"id" => id, "alert_trigger" => alert_trigger_params}) do
    alert_trigger = Portfolio.get_alert_trigger!(id)

    with {:ok, %AlertTrigger{} = alert_trigger} <- Portfolio.update_alert_trigger(alert_trigger, alert_trigger_params) do
      render(conn, "show.json", alert_trigger: alert_trigger)
    end
  end

  def delete(conn, %{"id" => id}) do
    alert_trigger = Portfolio.get_alert_trigger!(id)

    with {:ok, %AlertTrigger{}} <- Portfolio.delete_alert_trigger(alert_trigger) do
      send_resp(conn, :no_content, "")
    end
  end
end

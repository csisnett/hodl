defmodule HodlWeb.AlertTriggerView do
  use HodlWeb, :view
  alias HodlWeb.AlertTriggerView

  def render("index.json", %{alerttriggers: alerttriggers}) do
    %{data: render_many(alerttriggers, AlertTriggerView, "alert_trigger.json")}
  end

  def render("show.json", %{alert_trigger: alert_trigger}) do
    %{data: render_one(alert_trigger, AlertTriggerView, "alert_trigger.json")}
  end

  def render("alert_trigger.json", %{alert_trigger: alert_trigger}) do
    %{id: alert_trigger.id,
      type: alert_trigger.type}
  end
end

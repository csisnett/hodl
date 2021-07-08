defmodule HodlWeb.PlanView do
  use HodlWeb, :view
  alias HodlWeb.PlanView

  def render("index.json", %{plans: plans}) do
    %{data: render_many(plans, PlanView, "plan.json")}
  end

  def render("show.json", %{plan: plan}) do
    %{data: render_one(plan, PlanView, "plan.json")}
  end

  def render("plan.json", %{plan: plan}) do
    %{id: plan.id,
      name: plan.name,
      description: plan.description,
      email_limit: plan.email_limit,
      sms_limit: plan.sms_limit}
  end
end

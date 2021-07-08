defmodule HodlWeb.PlanController do
  use HodlWeb, :controller

  alias Hodl.Accounts
  alias Hodl.Accounts.Plan

  action_fallback HodlWeb.FallbackController

  def index(conn, _params) do
    plans = Accounts.list_plans()
    render(conn, "index.json", plans: plans)
  end

  def create(conn, %{"plan" => plan_params}) do
    with {:ok, %Plan{} = plan} <- Accounts.create_plan(plan_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.plan_path(conn, :show, plan))
      |> render("show.json", plan: plan)
    end
  end

  def show(conn, %{"id" => id}) do
    plan = Accounts.get_plan!(id)
    render(conn, "show.json", plan: plan)
  end

  def update(conn, %{"id" => id, "plan" => plan_params}) do
    plan = Accounts.get_plan!(id)

    with {:ok, %Plan{} = plan} <- Accounts.update_plan(plan, plan_params) do
      render(conn, "show.json", plan: plan)
    end
  end

  def delete(conn, %{"id" => id}) do
    plan = Accounts.get_plan!(id)

    with {:ok, %Plan{}} <- Accounts.delete_plan(plan) do
      send_resp(conn, :no_content, "")
    end
  end
end

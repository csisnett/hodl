defmodule HodlWeb.CycleController do
  use HodlWeb, :controller

  alias Hodl.Portfolio
  alias Hodl.Portfolio.Cycle

  action_fallback HodlWeb.FallbackController

  def index(conn, _params) do
    cycles = Portfolio.list_cycles()
    render(conn, "index.json", cycles: cycles)
  end

  def create(conn, %{"cycle" => cycle_params}) do
    with {:ok, %Cycle{} = cycle} <- Portfolio.create_cycle(cycle_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.cycle_path(conn, :show, cycle))
      |> render("show.json", cycle: cycle)
    end
  end

  def show(conn, %{"id" => id}) do
    cycle = Portfolio.get_cycle!(id)
    render(conn, "show.json", cycle: cycle)
  end

  def update(conn, %{"id" => id, "cycle" => cycle_params}) do
    cycle = Portfolio.get_cycle!(id)

    with {:ok, %Cycle{} = cycle} <- Portfolio.update_cycle(cycle, cycle_params) do
      render(conn, "show.json", cycle: cycle)
    end
  end

  def delete(conn, %{"id" => id}) do
    cycle = Portfolio.get_cycle!(id)

    with {:ok, %Cycle{}} <- Portfolio.delete_cycle(cycle) do
      send_resp(conn, :no_content, "")
    end
  end
end

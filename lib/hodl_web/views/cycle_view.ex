defmodule HodlWeb.CycleView do
  use HodlWeb, :view
  alias HodlWeb.CycleView

  def render("index.json", %{cycles: cycles}) do
    %{data: render_many(cycles, CycleView, "cycle.json")}
  end

  def render("show.json", %{cycle: cycle}) do
    %{data: render_one(cycle, CycleView, "cycle.json")}
  end

  def render("cycle.json", %{cycle: cycle}) do
    %{id: cycle.id,
      price_per_coin: cycle.price_per_coin}
  end
end

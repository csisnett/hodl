defmodule HodlWeb.CycleControllerTest do
  use HodlWeb.ConnCase

  alias Hodl.Portfolio
  alias Hodl.Portfolio.Cycle

  @create_attrs %{
    price_per_coin: "120.5"
  }
  @update_attrs %{
    price_per_coin: "456.7"
  }
  @invalid_attrs %{price_per_coin: nil}

  def fixture(:cycle) do
    {:ok, cycle} = Portfolio.create_cycle(@create_attrs)
    cycle
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all cycles", %{conn: conn} do
      conn = get(conn, Routes.cycle_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create cycle" do
    test "renders cycle when data is valid", %{conn: conn} do
      conn = post(conn, Routes.cycle_path(conn, :create), cycle: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.cycle_path(conn, :show, id))

      assert %{
               "id" => id,
               "price_per_coin" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.cycle_path(conn, :create), cycle: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update cycle" do
    setup [:create_cycle]

    test "renders cycle when data is valid", %{conn: conn, cycle: %Cycle{id: id} = cycle} do
      conn = put(conn, Routes.cycle_path(conn, :update, cycle), cycle: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.cycle_path(conn, :show, id))

      assert %{
               "id" => id,
               "price_per_coin" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, cycle: cycle} do
      conn = put(conn, Routes.cycle_path(conn, :update, cycle), cycle: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete cycle" do
    setup [:create_cycle]

    test "deletes chosen cycle", %{conn: conn, cycle: cycle} do
      conn = delete(conn, Routes.cycle_path(conn, :delete, cycle))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.cycle_path(conn, :show, cycle))
      end
    end
  end

  defp create_cycle(_) do
    cycle = fixture(:cycle)
    %{cycle: cycle}
  end
end

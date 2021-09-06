defmodule HodlWeb.AlertTriggerControllerTest do
  use HodlWeb.ConnCase

  alias Hodl.Portfolio
  alias Hodl.Portfolio.AlertTrigger

  @create_attrs %{
    type: "some type"
  }
  @update_attrs %{
    type: "some updated type"
  }
  @invalid_attrs %{type: nil}

  def fixture(:alert_trigger) do
    {:ok, alert_trigger} = Portfolio.create_alert_trigger(@create_attrs)
    alert_trigger
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all alerttriggers", %{conn: conn} do
      conn = get(conn, Routes.alert_trigger_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create alert_trigger" do
    test "renders alert_trigger when data is valid", %{conn: conn} do
      conn = post(conn, Routes.alert_trigger_path(conn, :create), alert_trigger: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.alert_trigger_path(conn, :show, id))

      assert %{
               "id" => id,
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.alert_trigger_path(conn, :create), alert_trigger: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update alert_trigger" do
    setup [:create_alert_trigger]

    test "renders alert_trigger when data is valid", %{conn: conn, alert_trigger: %AlertTrigger{id: id} = alert_trigger} do
      conn = put(conn, Routes.alert_trigger_path(conn, :update, alert_trigger), alert_trigger: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.alert_trigger_path(conn, :show, id))

      assert %{
               "id" => id,
               "type" => "some updated type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, alert_trigger: alert_trigger} do
      conn = put(conn, Routes.alert_trigger_path(conn, :update, alert_trigger), alert_trigger: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete alert_trigger" do
    setup [:create_alert_trigger]

    test "deletes chosen alert_trigger", %{conn: conn, alert_trigger: alert_trigger} do
      conn = delete(conn, Routes.alert_trigger_path(conn, :delete, alert_trigger))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.alert_trigger_path(conn, :show, alert_trigger))
      end
    end
  end

  defp create_alert_trigger(_) do
    alert_trigger = fixture(:alert_trigger)
    %{alert_trigger: alert_trigger}
  end
end

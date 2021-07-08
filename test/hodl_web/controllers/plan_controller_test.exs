defmodule HodlWeb.PlanControllerTest do
  use HodlWeb.ConnCase

  alias Hodl.Accounts
  alias Hodl.Accounts.Plan

  @create_attrs %{
    description: "some description",
    email_limit: 42,
    name: "some name",
    sms_limit: 42
  }
  @update_attrs %{
    description: "some updated description",
    email_limit: 43,
    name: "some updated name",
    sms_limit: 43
  }
  @invalid_attrs %{description: nil, email_limit: nil, name: nil, sms_limit: nil}

  def fixture(:plan) do
    {:ok, plan} = Accounts.create_plan(@create_attrs)
    plan
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all plans", %{conn: conn} do
      conn = get(conn, Routes.plan_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create plan" do
    test "renders plan when data is valid", %{conn: conn} do
      conn = post(conn, Routes.plan_path(conn, :create), plan: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.plan_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "email_limit" => 42,
               "name" => "some name",
               "sms_limit" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.plan_path(conn, :create), plan: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update plan" do
    setup [:create_plan]

    test "renders plan when data is valid", %{conn: conn, plan: %Plan{id: id} = plan} do
      conn = put(conn, Routes.plan_path(conn, :update, plan), plan: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.plan_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "email_limit" => 43,
               "name" => "some updated name",
               "sms_limit" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, plan: plan} do
      conn = put(conn, Routes.plan_path(conn, :update, plan), plan: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete plan" do
    setup [:create_plan]

    test "deletes chosen plan", %{conn: conn, plan: plan} do
      conn = delete(conn, Routes.plan_path(conn, :delete, plan))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.plan_path(conn, :show, plan))
      end
    end
  end

  defp create_plan(_) do
    plan = fixture(:plan)
    %{plan: plan}
  end
end

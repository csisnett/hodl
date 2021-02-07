defmodule HodlWeb.HodlscheduleControllerTest do
  use HodlWeb.ConnCase

  alias Hodl.Portfolio

  @create_attrs %{initial_coin_price: "120.5"}
  @update_attrs %{initial_coin_price: "456.7"}
  @invalid_attrs %{initial_coin_price: nil}

  def fixture(:hodlschedule) do
    {:ok, hodlschedule} = Portfolio.create_hodlschedule(@create_attrs)
    hodlschedule
  end

  describe "index" do
    test "lists all hodlschedules", %{conn: conn} do
      conn = get(conn, Routes.hodlschedule_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Hodlschedules"
    end
  end

  describe "new hodlschedule" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.hodlschedule_path(conn, :new))
      assert html_response(conn, 200) =~ "New Hodlschedule"
    end
  end

  describe "create hodlschedule" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.hodlschedule_path(conn, :create), hodlschedule: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.hodlschedule_path(conn, :show, id)

      conn = get(conn, Routes.hodlschedule_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Hodlschedule"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.hodlschedule_path(conn, :create), hodlschedule: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Hodlschedule"
    end
  end

  describe "edit hodlschedule" do
    setup [:create_hodlschedule]

    test "renders form for editing chosen hodlschedule", %{conn: conn, hodlschedule: hodlschedule} do
      conn = get(conn, Routes.hodlschedule_path(conn, :edit, hodlschedule))
      assert html_response(conn, 200) =~ "Edit Hodlschedule"
    end
  end

  describe "update hodlschedule" do
    setup [:create_hodlschedule]

    test "redirects when data is valid", %{conn: conn, hodlschedule: hodlschedule} do
      conn = put(conn, Routes.hodlschedule_path(conn, :update, hodlschedule), hodlschedule: @update_attrs)
      assert redirected_to(conn) == Routes.hodlschedule_path(conn, :show, hodlschedule)

      conn = get(conn, Routes.hodlschedule_path(conn, :show, hodlschedule))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, hodlschedule: hodlschedule} do
      conn = put(conn, Routes.hodlschedule_path(conn, :update, hodlschedule), hodlschedule: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Hodlschedule"
    end
  end

  describe "delete hodlschedule" do
    setup [:create_hodlschedule]

    test "deletes chosen hodlschedule", %{conn: conn, hodlschedule: hodlschedule} do
      conn = delete(conn, Routes.hodlschedule_path(conn, :delete, hodlschedule))
      assert redirected_to(conn) == Routes.hodlschedule_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.hodlschedule_path(conn, :show, hodlschedule))
      end
    end
  end

  defp create_hodlschedule(_) do
    hodlschedule = fixture(:hodlschedule)
    %{hodlschedule: hodlschedule}
  end
end

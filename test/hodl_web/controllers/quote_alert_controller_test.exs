defmodule HodlWeb.QuoteAlertControllerTest do
  use HodlWeb.ConnCase

  alias Hodl.Portfolio

  @create_attrs %{price_usd: "120.5"}
  @update_attrs %{price_usd: "456.7"}
  @invalid_attrs %{price_usd: nil}

  def fixture(:quote_alert) do
    {:ok, quote_alert} = Portfolio.create_quote_alert(@create_attrs)
    quote_alert
  end

  describe "index" do
    test "lists all quotealerts", %{conn: conn} do
      conn = get(conn, Routes.quote_alert_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Quotealerts"
    end
  end

  describe "new quote_alert" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.quote_alert_path(conn, :new))
      assert html_response(conn, 200) =~ "New Quote alert"
    end
  end

  describe "create quote_alert" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.quote_alert_path(conn, :create), quote_alert: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.quote_alert_path(conn, :show, id)

      conn = get(conn, Routes.quote_alert_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Quote alert"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.quote_alert_path(conn, :create), quote_alert: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Quote alert"
    end
  end

  describe "edit quote_alert" do
    setup [:create_quote_alert]

    test "renders form for editing chosen quote_alert", %{conn: conn, quote_alert: quote_alert} do
      conn = get(conn, Routes.quote_alert_path(conn, :edit, quote_alert))
      assert html_response(conn, 200) =~ "Edit Quote alert"
    end
  end

  describe "update quote_alert" do
    setup [:create_quote_alert]

    test "redirects when data is valid", %{conn: conn, quote_alert: quote_alert} do
      conn = put(conn, Routes.quote_alert_path(conn, :update, quote_alert), quote_alert: @update_attrs)
      assert redirected_to(conn) == Routes.quote_alert_path(conn, :show, quote_alert)

      conn = get(conn, Routes.quote_alert_path(conn, :show, quote_alert))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, quote_alert: quote_alert} do
      conn = put(conn, Routes.quote_alert_path(conn, :update, quote_alert), quote_alert: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Quote alert"
    end
  end

  describe "delete quote_alert" do
    setup [:create_quote_alert]

    test "deletes chosen quote_alert", %{conn: conn, quote_alert: quote_alert} do
      conn = delete(conn, Routes.quote_alert_path(conn, :delete, quote_alert))
      assert redirected_to(conn) == Routes.quote_alert_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.quote_alert_path(conn, :show, quote_alert))
      end
    end
  end

  defp create_quote_alert(_) do
    quote_alert = fixture(:quote_alert)
    %{quote_alert: quote_alert}
  end
end

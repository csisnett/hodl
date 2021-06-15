defmodule HodlWeb.CoinControllerTest do
  use HodlWeb.ConnCase

  alias Hodl.Portfolio

  @create_attrs %{name: "some name", symbol: "some symbol"}
  @update_attrs %{name: "some updated name", symbol: "some updated symbol"}
  @invalid_attrs %{name: nil, symbol: nil}

  def fixture(:coin) do
    {:ok, coin} = Portfolio.create_coin(@create_attrs)
    coin
  end

  describe "index" do
    test "lists all coins", %{conn: conn} do
      conn = get(conn, Routes.coin_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Coins"
    end
  end

  describe "new coin" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.coin_path(conn, :new))
      assert html_response(conn, 200) =~ "New Coin"
    end
  end

  describe "create coin" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.coin_path(conn, :create), coin: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.coin_path(conn, :show, id)

      conn = get(conn, Routes.coin_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Coin"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.coin_path(conn, :create), coin: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Coin"
    end
  end

  describe "edit coin" do
    setup [:create_coin]

    test "renders form for editing chosen coin", %{conn: conn, coin: coin} do
      conn = get(conn, Routes.coin_path(conn, :edit, coin))
      assert html_response(conn, 200) =~ "Edit Coin"
    end
  end

  describe "update coin" do
    setup [:create_coin]

    test "redirects when data is valid", %{conn: conn, coin: coin} do
      conn = put(conn, Routes.coin_path(conn, :update, coin), coin: @update_attrs)
      assert redirected_to(conn) == Routes.coin_path(conn, :show, coin)

      conn = get(conn, Routes.coin_path(conn, :show, coin))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, coin: coin} do
      conn = put(conn, Routes.coin_path(conn, :update, coin), coin: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Coin"
    end
  end

  describe "delete coin" do
    setup [:create_coin]

    test "deletes chosen coin", %{conn: conn, coin: coin} do
      conn = delete(conn, Routes.coin_path(conn, :delete, coin))
      assert redirected_to(conn) == Routes.coin_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.coin_path(conn, :show, coin))
      end
    end
  end

  defp create_coin(_) do
    coin = fixture(:coin)
    %{coin: coin}
  end
end

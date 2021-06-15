defmodule HodlWeb.RankingControllerTest do
  use HodlWeb.ConnCase

  alias Hodl.Portfolio

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:ranking) do
    {:ok, ranking} = Portfolio.create_ranking(@create_attrs)
    ranking
  end

  describe "index" do
    test "lists all rankings", %{conn: conn} do
      conn = get(conn, Routes.ranking_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Rankings"
    end
  end

  describe "new ranking" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.ranking_path(conn, :new))
      assert html_response(conn, 200) =~ "New Ranking"
    end
  end

  describe "create ranking" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.ranking_path(conn, :create), ranking: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.ranking_path(conn, :show, id)

      conn = get(conn, Routes.ranking_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Ranking"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.ranking_path(conn, :create), ranking: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Ranking"
    end
  end

  describe "edit ranking" do
    setup [:create_ranking]

    test "renders form for editing chosen ranking", %{conn: conn, ranking: ranking} do
      conn = get(conn, Routes.ranking_path(conn, :edit, ranking))
      assert html_response(conn, 200) =~ "Edit Ranking"
    end
  end

  describe "update ranking" do
    setup [:create_ranking]

    test "redirects when data is valid", %{conn: conn, ranking: ranking} do
      conn = put(conn, Routes.ranking_path(conn, :update, ranking), ranking: @update_attrs)
      assert redirected_to(conn) == Routes.ranking_path(conn, :show, ranking)

      conn = get(conn, Routes.ranking_path(conn, :show, ranking))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, ranking: ranking} do
      conn = put(conn, Routes.ranking_path(conn, :update, ranking), ranking: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Ranking"
    end
  end

  describe "delete ranking" do
    setup [:create_ranking]

    test "deletes chosen ranking", %{conn: conn, ranking: ranking} do
      conn = delete(conn, Routes.ranking_path(conn, :delete, ranking))
      assert redirected_to(conn) == Routes.ranking_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.ranking_path(conn, :show, ranking))
      end
    end
  end

  defp create_ranking(_) do
    ranking = fixture(:ranking)
    %{ranking: ranking}
  end
end

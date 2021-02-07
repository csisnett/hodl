defmodule Hodl.PortfolioTest do
  use Hodl.DataCase

  alias Hodl.Portfolio

  describe "coins" do
    alias Hodl.Portfolio.Coin

    @valid_attrs %{name: "some name", symbol: "some symbol"}
    @update_attrs %{name: "some updated name", symbol: "some updated symbol"}
    @invalid_attrs %{name: nil, symbol: nil}

    def coin_fixture(attrs \\ %{}) do
      {:ok, coin} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Portfolio.create_coin()

      coin
    end

    test "list_coins/0 returns all coins" do
      coin = coin_fixture()
      assert Portfolio.list_coins() == [coin]
    end

    test "get_coin!/1 returns the coin with given id" do
      coin = coin_fixture()
      assert Portfolio.get_coin!(coin.id) == coin
    end

    test "create_coin/1 with valid data creates a coin" do
      assert {:ok, %Coin{} = coin} = Portfolio.create_coin(@valid_attrs)
      assert coin.name == "some name"
      assert coin.symbol == "some symbol"
    end

    test "create_coin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Portfolio.create_coin(@invalid_attrs)
    end

    test "update_coin/2 with valid data updates the coin" do
      coin = coin_fixture()
      assert {:ok, %Coin{} = coin} = Portfolio.update_coin(coin, @update_attrs)
      assert coin.name == "some updated name"
      assert coin.symbol == "some updated symbol"
    end

    test "update_coin/2 with invalid data returns error changeset" do
      coin = coin_fixture()
      assert {:error, %Ecto.Changeset{}} = Portfolio.update_coin(coin, @invalid_attrs)
      assert coin == Portfolio.get_coin!(coin.id)
    end

    test "delete_coin/1 deletes the coin" do
      coin = coin_fixture()
      assert {:ok, %Coin{}} = Portfolio.delete_coin(coin)
      assert_raise Ecto.NoResultsError, fn -> Portfolio.get_coin!(coin.id) end
    end

    test "change_coin/1 returns a coin changeset" do
      coin = coin_fixture()
      assert %Ecto.Changeset{} = Portfolio.change_coin(coin)
    end
  end
end

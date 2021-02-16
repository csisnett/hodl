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

  describe "hodlschedules" do
    alias Hodl.Portfolio.Hodlschedule

    @valid_attrs %{initial_coin_price: "120.5"}
    @update_attrs %{initial_coin_price: "456.7"}
    @invalid_attrs %{initial_coin_price: nil}

    def hodlschedule_fixture(attrs \\ %{}) do
      {:ok, hodlschedule} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Portfolio.create_hodlschedule()

      hodlschedule
    end

    test "list_hodlschedules/0 returns all hodlschedules" do
      hodlschedule = hodlschedule_fixture()
      assert Portfolio.list_hodlschedules() == [hodlschedule]
    end

    test "get_hodlschedule!/1 returns the hodlschedule with given id" do
      hodlschedule = hodlschedule_fixture()
      assert Portfolio.get_hodlschedule!(hodlschedule.id) == hodlschedule
    end

    test "create_hodlschedule/1 with valid data creates a hodlschedule" do
      assert {:ok, %Hodlschedule{} = hodlschedule} = Portfolio.create_hodlschedule(@valid_attrs)
      assert hodlschedule.initial_coin_price == Decimal.new("120.5")
    end

    test "create_hodlschedule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Portfolio.create_hodlschedule(@invalid_attrs)
    end

    test "update_hodlschedule/2 with valid data updates the hodlschedule" do
      hodlschedule = hodlschedule_fixture()
      assert {:ok, %Hodlschedule{} = hodlschedule} = Portfolio.update_hodlschedule(hodlschedule, @update_attrs)
      assert hodlschedule.initial_coin_price == Decimal.new("456.7")
    end

    test "update_hodlschedule/2 with invalid data returns error changeset" do
      hodlschedule = hodlschedule_fixture()
      assert {:error, %Ecto.Changeset{}} = Portfolio.update_hodlschedule(hodlschedule, @invalid_attrs)
      assert hodlschedule == Portfolio.get_hodlschedule!(hodlschedule.id)
    end

    test "delete_hodlschedule/1 deletes the hodlschedule" do
      hodlschedule = hodlschedule_fixture()
      assert {:ok, %Hodlschedule{}} = Portfolio.delete_hodlschedule(hodlschedule)
      assert_raise Ecto.NoResultsError, fn -> Portfolio.get_hodlschedule!(hodlschedule.id) end
    end

    test "change_hodlschedule/1 returns a hodlschedule changeset" do
      hodlschedule = hodlschedule_fixture()
      assert %Ecto.Changeset{} = Portfolio.change_hodlschedule(hodlschedule)
    end
  end

  describe "cycles" do
    alias Hodl.Portfolio.Cycle

    @valid_attrs %{price_per_coin: "120.5"}
    @update_attrs %{price_per_coin: "456.7"}
    @invalid_attrs %{price_per_coin: nil}

    def cycle_fixture(attrs \\ %{}) do
      {:ok, cycle} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Portfolio.create_cycle()

      cycle
    end

    test "list_cycles/0 returns all cycles" do
      cycle = cycle_fixture()
      assert Portfolio.list_cycles() == [cycle]
    end

    test "get_cycle!/1 returns the cycle with given id" do
      cycle = cycle_fixture()
      assert Portfolio.get_cycle!(cycle.id) == cycle
    end

    test "create_cycle/1 with valid data creates a cycle" do
      assert {:ok, %Cycle{} = cycle} = Portfolio.create_cycle(@valid_attrs)
      assert cycle.price_per_coin == Decimal.new("120.5")
    end

    test "create_cycle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Portfolio.create_cycle(@invalid_attrs)
    end

    test "update_cycle/2 with valid data updates the cycle" do
      cycle = cycle_fixture()
      assert {:ok, %Cycle{} = cycle} = Portfolio.update_cycle(cycle, @update_attrs)
      assert cycle.price_per_coin == Decimal.new("456.7")
    end

    test "update_cycle/2 with invalid data returns error changeset" do
      cycle = cycle_fixture()
      assert {:error, %Ecto.Changeset{}} = Portfolio.update_cycle(cycle, @invalid_attrs)
      assert cycle == Portfolio.get_cycle!(cycle.id)
    end

    test "delete_cycle/1 deletes the cycle" do
      cycle = cycle_fixture()
      assert {:ok, %Cycle{}} = Portfolio.delete_cycle(cycle)
      assert_raise Ecto.NoResultsError, fn -> Portfolio.get_cycle!(cycle.id) end
    end

    test "change_cycle/1 returns a cycle changeset" do
      cycle = cycle_fixture()
      assert %Ecto.Changeset{} = Portfolio.change_cycle(cycle)
    end
  end

  describe "quotes" do
    alias Hodl.Portfolio.Quote

    @valid_attrs %{price_usd: "120.5"}
    @update_attrs %{price_usd: "456.7"}
    @invalid_attrs %{price_usd: nil}

    def quote_fixture(attrs \\ %{}) do
      {:ok, quote} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Portfolio.create_quote()

      quote
    end

    test "list_quotes/0 returns all quotes" do
      quote = quote_fixture()
      assert Portfolio.list_quotes() == [quote]
    end

    test "get_quote!/1 returns the quote with given id" do
      quote = quote_fixture()
      assert Portfolio.get_quote!(quote.id) == quote
    end

    test "create_quote/1 with valid data creates a quote" do
      assert {:ok, %Quote{} = quote} = Portfolio.create_quote(@valid_attrs)
      assert quote.price_usd == Decimal.new("120.5")
    end

    test "create_quote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Portfolio.create_quote(@invalid_attrs)
    end

    test "update_quote/2 with valid data updates the quote" do
      quote = quote_fixture()
      assert {:ok, %Quote{} = quote} = Portfolio.update_quote(quote, @update_attrs)
      assert quote.price_usd == Decimal.new("456.7")
    end

    test "update_quote/2 with invalid data returns error changeset" do
      quote = quote_fixture()
      assert {:error, %Ecto.Changeset{}} = Portfolio.update_quote(quote, @invalid_attrs)
      assert quote == Portfolio.get_quote!(quote.id)
    end

    test "delete_quote/1 deletes the quote" do
      quote = quote_fixture()
      assert {:ok, %Quote{}} = Portfolio.delete_quote(quote)
      assert_raise Ecto.NoResultsError, fn -> Portfolio.get_quote!(quote.id) end
    end

    test "change_quote/1 returns a quote changeset" do
      quote = quote_fixture()
      assert %Ecto.Changeset{} = Portfolio.change_quote(quote)
    end
  end
end

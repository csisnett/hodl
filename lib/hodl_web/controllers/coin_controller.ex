defmodule HodlWeb.CoinController do
  use HodlWeb, :controller

  alias Hodl.Portfolio
  alias Hodl.Portfolio.Coin

  def index(conn, _params) do
    coins = Portfolio.list_coins()
    render(conn, "index.html", coins: coins)
  end

  def new(conn, _params) do
    changeset = Portfolio.change_coin(%Coin{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"coin" => coin_params}) do
    case Portfolio.create_coin(coin_params) do
      {:ok, coin} ->
        conn
        |> put_flash(:info, "Coin created successfully.")
        |> redirect(to: Routes.coin_path(conn, :show, coin))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    coin = Portfolio.get_coin!(id)
    render(conn, "show.html", coin: coin)
  end

  def top_coins(conn, %{}) do
    coins = Portfolio.get_top_coins_quotes()
    json(conn, %{"coins" => coins})
  end

  def these_coins(conn, %{"coin_string" => coin_string}) do
    coins = Portfolio.list_these_coins(coin_string)
    json(conn, %{"coins" => coins})
  end

  def edit(conn, %{"id" => id}) do
    coin = Portfolio.get_coin!(id)
    changeset = Portfolio.change_coin(coin)
    render(conn, "edit.html", coin: coin, changeset: changeset)
  end

  def update(conn, %{"id" => id, "coin" => coin_params}) do
    coin = Portfolio.get_coin!(id)

    case Portfolio.update_coin(coin, coin_params) do
      {:ok, coin} ->
        conn
        |> put_flash(:info, "Coin updated successfully.")
        |> redirect(to: Routes.coin_path(conn, :show, coin))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", coin: coin, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    coin = Portfolio.get_coin!(id)
    {:ok, _coin} = Portfolio.delete_coin(coin)

    conn
    |> put_flash(:info, "Coin deleted successfully.")
    |> redirect(to: Routes.coin_path(conn, :index))
  end
end

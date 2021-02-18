defmodule Hodl.Portfolio do
  @moduledoc """
  The Portfolio context.
  """

  import Ecto.Query, warn: false
  alias Hodl.Repo

  alias Hodl.Portfolio.Coin

  @doc """
  Returns the list of coins.

  ## Examples

      iex> list_coins()
      [%Coin{}, ...]

  """
  def list_coins do
    Repo.all(Coin)
  end

  @doc """
  Gets a single coin.

  Raises `Ecto.NoResultsError` if the Coin does not exist.

  ## Examples

      iex> get_coin!(123)
      %Coin{}

      iex> get_coin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_coin!(id), do: Repo.get!(Coin, id)

  @doc """
  Creates a coin.

  ## Examples

      iex> create_coin(%{field: value})
      {:ok, %Coin{}}

      iex> create_coin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_coin(attrs \\ %{}) do
    %Coin{}
    |> Coin.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a coin.

  ## Examples

      iex> update_coin(coin, %{field: new_value})
      {:ok, %Coin{}}

      iex> update_coin(coin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_coin(%Coin{} = coin, attrs) do
    coin
    |> Coin.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a coin.

  ## Examples

      iex> delete_coin(coin)
      {:ok, %Coin{}}

      iex> delete_coin(coin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_coin(%Coin{} = coin) do
    Repo.delete(coin)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking coin changes.

  ## Examples

      iex> change_coin(coin)
      %Ecto.Changeset{data: %Coin{}}

  """
  def change_coin(%Coin{} = coin, attrs \\ %{}) do
    Coin.changeset(coin, attrs)
  end

  alias Hodl.Portfolio.Hodlschedule

  @doc """
  Returns the list of hodlschedules.

  ## Examples

      iex> list_hodlschedules()
      [%Hodlschedule{}, ...]

  """
  def list_hodlschedules do
    Repo.all(Hodlschedule)
  end

  @doc """
  Gets a single hodlschedule.

  Raises `Ecto.NoResultsError` if the Hodlschedule does not exist.

  ## Examples

      iex> get_hodlschedule!(123)
      %Hodlschedule{}

      iex> get_hodlschedule!(456)
      ** (Ecto.NoResultsError)

  """
  def get_hodlschedule!(id), do: Repo.get!(Hodlschedule, id)

  @doc """
  Creates a hodlschedule.

  ## Examples

      iex> create_hodlschedule(%{field: value})
      {:ok, %Hodlschedule{}}

      iex> create_hodlschedule(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_hodlschedule(attrs \\ %{}) do
    %Hodlschedule{}
    |> Hodlschedule.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a hodlschedule.

  ## Examples

      iex> update_hodlschedule(hodlschedule, %{field: new_value})
      {:ok, %Hodlschedule{}}

      iex> update_hodlschedule(hodlschedule, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_hodlschedule(%Hodlschedule{} = hodlschedule, attrs) do
    hodlschedule
    |> Hodlschedule.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a hodlschedule.

  ## Examples

      iex> delete_hodlschedule(hodlschedule)
      {:ok, %Hodlschedule{}}

      iex> delete_hodlschedule(hodlschedule)
      {:error, %Ecto.Changeset{}}

  """
  def delete_hodlschedule(%Hodlschedule{} = hodlschedule) do
    Repo.delete(hodlschedule)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking hodlschedule changes.

  ## Examples

      iex> change_hodlschedule(hodlschedule)
      %Ecto.Changeset{data: %Hodlschedule{}}

  """
  def change_hodlschedule(%Hodlschedule{} = hodlschedule, attrs \\ %{}) do
    Hodlschedule.changeset(hodlschedule, attrs)
  end

  alias Hodl.Portfolio.Cycle

  @doc """
  Returns the list of cycles.

  ## Examples

      iex> list_cycles()
      [%Cycle{}, ...]

  """
  def list_cycles do
    Repo.all(Cycle)
  end

  @doc """
  Gets a single cycle.

  Raises `Ecto.NoResultsError` if the Cycle does not exist.

  ## Examples

      iex> get_cycle!(123)
      %Cycle{}

      iex> get_cycle!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cycle!(id), do: Repo.get!(Cycle, id)

  @doc """
  Creates a cycle.

  ## Examples

      iex> create_cycle(%{field: value})
      {:ok, %Cycle{}}

      iex> create_cycle(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cycle(attrs \\ %{}) do
    %Cycle{}
    |> Cycle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cycle.

  ## Examples

      iex> update_cycle(cycle, %{field: new_value})
      {:ok, %Cycle{}}

      iex> update_cycle(cycle, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cycle(%Cycle{} = cycle, attrs) do
    cycle
    |> Cycle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cycle.

  ## Examples

      iex> delete_cycle(cycle)
      {:ok, %Cycle{}}

      iex> delete_cycle(cycle)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cycle(%Cycle{} = cycle) do
    Repo.delete(cycle)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cycle changes.

  ## Examples

      iex> change_cycle(cycle)
      %Ecto.Changeset{data: %Cycle{}}

  """
  def change_cycle(%Cycle{} = cycle, attrs \\ %{}) do
    Cycle.changeset(cycle, attrs)
  end

  alias Hodl.Portfolio.Quote

  @doc """
  Returns the list of quotes.

  ## Examples

      iex> list_quotes()
      [%Quote{}, ...]

  """
  def list_quotes do
    Repo.all(Quote)
  end

  def test_api do
    api_key = System.get_env("MARKETCAP_TEST_KEY")

    {:ok, response} = HTTPoison.get("https://sandbox-api.coinmarketcap.com/v1/cryptocurrency/listings/latest", [{"Content-Type", "application/json"}, {"Accept", "application/json"}, {"Accept-Encoding", "application/json"}, {"charset", "utf-8"}, {"X-CMC_PRO_API_KEY", api_key}])
    {:ok, response_body} = Jason.decode(response.body)
  end

  def get_crypto_ids do
    api_key = System.get_env("MARKETCAP_KEY")
    {:ok, response} = HTTPoison.get("https://pro-api.coinmarketcap.com/v1/cryptocurrency/map", [{"Content-Type", "application/json"}, {"Accept", "application/json"}, {"Accept-Encoding", "application/json"}, {"charset", "utf-8"}, {"X-CMC_PRO_API_KEY", api_key}])
    {:ok, response_body} = Jason.decode(response.body)
    %{"data" => data} = response_body
    Enum.map(data, fn crypto -> Map.put(crypto, "coinmarketcap_id", crypto["id"])end)
  end

  def get_coins_quotes do
    api_key = System.get_env("MARKETCAP_KEY")

    {:ok, response} = HTTPoison.get("https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest", [{"Accept", "application/json"}, {"Accept-Encoding", "application/json"}, {"charset", "utf-8"}, {"X-CMC_PRO_API_KEY", api_key}])
    {:ok, response_body} = Jason.decode(response.body)
    %{"data" => data} = response_body
    data
  end

  def create_coins([]) do
    []
  end

  def create_coins(coin_list) do
    [first | rest] = coin_list
    {:ok, coin} = create_coin(first)
    create_coins(rest)
  end

  def get_quote_info(%{} = coin) do
    price = coin["quote"]["USD"]["price"]
    coinmarketcap_id = coin["id"]
    %{"price_usd" => price, "coinmarketcap_id" => coinmarketcap_id}
  end

  def create_new_quotes do
    coins = get_coins_quotes()
    Enum.each(coins, fn coin -> get_quote_info(coin) |> create_new_quote end)
  end

  def create_new_quote(%{"coinmarketcap_id" => id} = quote_params) do
    coin = Repo.get_by(Coin, coinmarketcap_id: id)
    quote_params = Map.put(quote_params, "coin_id", coin.id)
    create_quote(quote_params)
  end

  @doc """
  Gets a single quote.

  Raises `Ecto.NoResultsError` if the Quote does not exist.

  ## Examples

      iex> get_quote!(123)
      %Quote{}

      iex> get_quote!(456)
      ** (Ecto.NoResultsError)

  """
  def get_quote!(id), do: Repo.get!(Quote, id)

  @doc """
  Creates a quote.

  ## Examples

      iex> create_quote(%{field: value})
      {:ok, %Quote{}}

      iex> create_quote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_quote(attrs \\ %{}) do
    %Quote{}
    |> Quote.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a quote.

  ## Examples

      iex> update_quote(quote, %{field: new_value})
      {:ok, %Quote{}}

      iex> update_quote(quote, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_quote(%Quote{} = quote, attrs) do
    quote
    |> Quote.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a quote.

  ## Examples

      iex> delete_quote(quote)
      {:ok, %Quote{}}

      iex> delete_quote(quote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_quote(%Quote{} = quote) do
    Repo.delete(quote)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking quote changes.

  ## Examples

      iex> change_quote(quote)
      %Ecto.Changeset{data: %Quote{}}

  """
  def change_quote(%Quote{} = quote, attrs \\ %{}) do
    Quote.changeset(quote, attrs)
  end
end

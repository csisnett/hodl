defmodule Hodl.Portfolio do
  @moduledoc """
  The Portfolio context.
  """

  import Ecto.Query, warn: false
  alias Hodl.Repo
  alias Hodl.Portfolio
  alias Hodl.Portfolio.{Coin, Coinrank, Cycle, Hodlschedule, Quote, Ranking}
  alias Hodl.Users.User

  def get_user!(id), do: Repo.get!(User, id)

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

  def get_coin_by_uuid(uuid), do: Repo.get_by(Coin, uuid: uuid)

  @doc """
  Creates a coin.

  ## Examples

      iex> create_coin(%{field: value})
      {:ok, %Coin{}}

      iex> create_coin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_coin(attrs \\ %{}) do
    case attrs["external_platform_id"] do
      nil ->
        %Coin{}
        |> Coin.changeset(attrs)
        |> Repo.insert()
      external_platform_id ->
        platform_coin = Repo.get_by(Coin, coinmarketcap_id: external_platform_id)
        attrs = attrs |> Map.put("platform_id", platform_coin.id)
        %Coin{}
        |> Coin.changeset(attrs)
        |> Repo.insert()
    end
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

  def create_hodlschedule!(attrs \\ %{}) do
    %Hodlschedule{}
    |> Hodlschedule.changeset(attrs)
    |> Repo.insert!()
  end

  def test_hodl_schedule() do
    attrs = %{"coin_uuid" => "ufbF6ASdoJRViWysbhp6m4", "cycles" => [%{"amount_of_coin" => 10, "price_per_coin" => 20.21}, %{"amount_of_coin" => 5, "price_per_coin" => 202.1}]}
    user = get_user!(1)
    create_hodlschedule(attrs, user)
  end

  # %{"coin_uuid", => "askfmlsamfsa", "cycles" => [%{"amount_of_coin" => 2, "price_per_coin" => 20.23}, ...]}, %User{} -> {:ok, %Hodlschedule{}} || Raises error
  def create_hodlschedule(%{} = attrs, %User{} = user) do
    coin = get_coin_by_uuid(attrs["coin_uuid"])
    hodlschedule_attrs = %{"coin_id" => coin.id, "user_id" => user.id}
    cycles = attrs["cycles"] |> Enum.reverse()
    Repo.transaction(fn ->
      hodlschedule = create_hodlschedule!(hodlschedule_attrs)
      create_cycles!(cycles, hodlschedule, [])
    end)
  end

  #[%{"price_per_coin", "amount_per_coin", }], Hodlschedule, [] -> [%Cycle{}, ...]
  # Receives a list of cycle attrs and creates the respective cycles
  # About
  #The cycles are received from last to first order. 
  #They're created in that order as well in order to have the next_cycle_id
  def create_cycles!(cycles, %Hodlschedule{} = hodlschedule, result) do
    [current_attrs | rest] = cycles

    current_attrs = case length(cycles) do
      1 -> current_attrs = Map.put(current_attrs, "first?", true)
      n -> current_attrs = Map.put(current_attrs, "first?", false)
    end

    current_cycle = create_cycle!(current_attrs,hodlschedule)
    result = result ++ [current_cycle]
    case length(rest) do
      0 -> result |> Enum.reverse()
      n -> 
        [parent_attrs | others] = rest
        parent_attrs = parent_attrs |> Map.put("next_cycle_id", current_cycle.id)
        create_cycles!( [parent_attrs | others], hodlschedule, result)
    end 
  end

  def create_cycle!(%{} = attrs, %Hodlschedule{} = hodlschedule) do
    attrs = Map.put(attrs, "hodlschedule_id", hodlschedule.id)
    create_cycle!(attrs)
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

  def create_cycle!(attrs \\ %{}) do
    %Cycle{}
    |> Cycle.changeset(attrs)
    |> Repo.insert!()
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

  @doc """
  Returns the list of quotes.

  ## Examples

      iex> list_quotes()
      [%Quote{}, ...]

  """
  def list_quotes do
    Repo.all(Quote)
  end

  # Test of the coin market cap API
  def test_api do
    api_key = System.get_env("MARKETCAP_TEST_KEY")

    {:ok, response} = HTTPoison.get("https://sandbox-api.coinmarketcap.com/v1/cryptocurrency/listings/latest", [{"Content-Type", "application/json"}, {"Accept", "application/json"}, {"Accept-Encoding", "application/json"}, {"charset", "utf-8"}, {"X-CMC_PRO_API_KEY", api_key}])
    {:ok, response_body} = Jason.decode(response.body)
  end

  # Returns all the cryptos in coin market cap and prepares them for insertion into the db
  def get_crypto_ids do
    api_key = System.get_env("MARKETCAP_KEY")
    {:ok, response} = HTTPoison.get("https://pro-api.coinmarketcap.com/v1/cryptocurrency/map", [{"Content-Type", "application/json"}, {"Accept", "application/json"}, {"Accept-Encoding", "application/json"}, {"charset", "utf-8"}, {"X-CMC_PRO_API_KEY", api_key}])
    {:ok, response_body} = Jason.decode(response.body)
    %{"data" => data} = response_body
    Enum.map(data, fn crypto -> prepare_coin_for_creation(crypto)end)
  end

  def prepare_coin_for_creation(%{} = crypto) do
    crypto
    |> Map.put(crypto, "coinmarketcap_id", crypto["id"])
    |> Map.put(crypto, "external_platform_id", crypto["platform"]["id"])
    |> Map.put(crypto, "token_address", crypto["platform"]["token_address"])
  end

  # Takes a list of coin params and creates the coins that are platforms only
  def create_platform_coins(coin_list) do
    coin_platforms = Enum.filter(coin_list, fn coin -> coin["platform"] == nil end)
    create_coins(coin_platforms)
  end

   # Takes a list of coin params and creates the coins that are tokens only
  def create_token_coins(coin_list) do
    tokens = Enum.filter(coin_list, fn coin -> coin["platform"] != nil end)
    create_coins(tokens)
  end

    # Base case of the following function
  def create_coins([]) do
    []
  end

  # [%{}, ...] ->  []
  # Takes a list of coins maps as inputs and creates the %Coins{}. Returns an empty list
  def create_coins(coin_list) do
    [first | rest] = coin_list
    coin = Repo.get_by(Coin, coinmarketcap_id: first["id"])
    case coin do
    nil -> 
      {:ok, coin} = create_coin(first)
      create_coins(rest)

    coin -> create_coins(rest)
    end
  end

  # %{"id" => 2, "quote" => %{"USD" => %{"price" => 12.0}}} -> %{"coinmarketcap_id" => 2, "price_usd" => 12.0}
  # Puts the important info of the coin into the root map
  def get_quote_info(%{} = coin) do
    price = coin["quote"]["USD"]["price"]
    coinmarketcap_id = coin["id"]
    %{"price_usd" => price, "coinmarketcap_id" => coinmarketcap_id}
  end

  # -> [%{"id" => 1, .. "quote" => %{"USD" => %{"price" => 12.0}}}, ...]
  #Gets the quotes in USD and metadata of the current top 100 cryptos in coinmarketcap
  def get_top_quotes do
    api_key = System.get_env("MARKETCAP_KEY")

    {:ok, response} = HTTPoison.get("https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest", [{"Accept", "application/json"}, {"Accept-Encoding", "application/json"}, {"charset", "utf-8"}, {"X-CMC_PRO_API_KEY", api_key}])
    {:ok, response_body} = Jason.decode(response.body)
    %{"data" => data} = response_body
    data
  end

  # [%Coin{id: 1}, ...] -> %{"1" => %{...}, ...}
  # Gets the quotes from the list of coins given
  def get_coin_quote(coins) when is_list(coins) do
    {_, ids} = Enum.map_reduce(coins, "", fn coin, acc -> {coin, acc <> ","  <> Integer.to_string(coin.coinmarketcap_id)}end)
    ids = String.slice(ids, 1..-1) #Slice leading comma
    api_key = System.get_env("MARKETCAP_KEY")
    params = [id: ids]
    {:ok, response} = HTTPoison.get("https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest", [{"Accept", "application/json"}, {"Accept-Encoding", "application/json"}, {"charset", "utf-8"}, {"X-CMC_PRO_API_KEY", api_key}], [params: params])
    {:ok, response_body} = Jason.decode(response.body)
    %{"data" => data} = response_body
    data
  end

  def test_oban_job do
    %{"name" => "get_top_quotes"}
    |> Portfolio.QuoteWorker.new(schedule_in: 60)
    |> Oban.insert()
  end

  # [%{}] -> :ok
  # Creates a %Quote{} for each quote param given
  def create_new_quotes(quotes_params) when is_list(quotes_params) do
    Enum.each(quotes_params, fn coin -> get_quote_info(coin) |> create_new_quote end)
  end

  # map -> {:ok, %Quote{}} || {:error, %Changeset{}}
  # Creates a new quote from the map params given
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

  @doc """
  Returns the list of rankings.

  ## Examples

      iex> list_rankings()
      [%Ranking{}, ...]

  """
  def list_rankings do
    Repo.all(Ranking)
  end

  @doc """
  Gets a single ranking.

  Raises `Ecto.NoResultsError` if the Ranking does not exist.

  ## Examples

      iex> get_ranking!(123)
      %Ranking{}

      iex> get_ranking!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ranking!(id), do: Repo.get!(Ranking, id)

  @doc """
  Creates a ranking.

  ## Examples

      iex> create_ranking(%{field: value})
      {:ok, %Ranking{}}

      iex> create_ranking(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ranking(attrs \\ %{}) do
    %Ranking{}
    |> Ranking.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ranking.

  ## Examples

      iex> update_ranking(ranking, %{field: new_value})
      {:ok, %Ranking{}}

      iex> update_ranking(ranking, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ranking(%Ranking{} = ranking, attrs) do
    ranking
    |> Ranking.changeset(attrs)
    |> Repo.update()
  end

  def get_or_create_coin(%{} = params) do
    coin = Repo.get_by(Coin, coinmarketcap_id: params["id"])
    case coin do
      nil -> 
        {:ok, coin} = prepare_coin_for_creation(params) |> create_coin()
        coin |> Map.put("cmc_rank", params["cmc_rank"])
      coin ->
        coin |> Map.put("cmc_rank", params["cmc_rank"])
    end
  end

  def delete_all_coinranks(%Ranking{id: id} = ranking) do
    from(c in Coinrank, where: c.ranking_id == ^id) |> Repo.delete_all
  end

  def prepare_for_coinrank_creation(%Coin{} = coin, %Ranking{} = ranking) do
    %{"position" => coin["cmc_rank"], "coin_id" => coin.id, "ranking_id" => ranking.id}
  end

  def insert_all_coinranks(%Ranking{} = ranking, coins_params) when is_list(coins_params) do
    coins = Enum.map(coins_params, fn coin_params -> get_or_create_coin(coin_params) end)
    Enum.each(coins, fn coin -> prepare_for_coinrank_creation(coin, ranking) |> create_coinrank() end)
  end

  def update_ranks(%Ranking{} = ranking) do
    cmc_coins = get_top_quotes()

    Repo.transaction(fn ->
      delete_all_coinranks(ranking)
      insert_all_coinranks(ranking, cmc_coins)
    end)
  end

  def get_ranking_coins(%Ranking{} = ranking) do
    query = from c in Coin,
    inner_join: cr in Coinrank,
    on: c.id == cr.coin_id,
    where: cr.ranking_id == ^ranking.id,
    order_by: cr.position,
    select: c
    Repo.all(query)
  end

  def get_top_coins_quotes() do
    ranking = Portfolio.get_ranking!(1)
    coins = get_ranking_coins(ranking)
    coins_quotes = Enum.map(coins, fn coin -> Map.put(coin, :price_usd, last_quote(coin))end)
  end

  def last_quote(%Coin{} = coin) do
    query = from q in Quote,
    where: q.coin_id == ^coin.id,
    order_by: [desc: q.inserted_at],
    limit: 1,
    select: q.price_usd
    Repo.one(query)
  end

  def get_top_coins() do
    ranking = Portfolio.get_ranking!(1)
    get_ranking_coins(ranking)
  end

  @doc """
  Deletes a ranking.

  ## Examples

      iex> delete_ranking(ranking)
      {:ok, %Ranking{}}

      iex> delete_ranking(ranking)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ranking(%Ranking{} = ranking) do
    Repo.delete(ranking)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ranking changes.

  ## Examples

      iex> change_ranking(ranking)
      %Ecto.Changeset{data: %Ranking{}}

  """
  def change_ranking(%Ranking{} = ranking, attrs \\ %{}) do
    Ranking.changeset(ranking, attrs)
  end

  @doc """
  Returns the list of coinranks.

  ## Examples

      iex> list_coinranks()
      [%Coinrank{}, ...]

  """
  def list_coinranks do
    Repo.all(Coinrank)
  end

  @doc """
  Gets a single coinrank.

  Raises `Ecto.NoResultsError` if the Coinrank does not exist.

  ## Examples

      iex> get_coinrank!(123)
      %Coinrank{}

      iex> get_coinrank!(456)
      ** (Ecto.NoResultsError)

  """
  def get_coinrank!(id), do: Repo.get!(Coinrank, id)

  @doc """
  Creates a coinrank.

  ## Examples

      iex> create_coinrank(%{field: value})
      {:ok, %Coinrank{}}

      iex> create_coinrank(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_coinrank(attrs \\ %{}) do
    %Coinrank{}
    |> Coinrank.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a coinrank.

  ## Examples

      iex> update_coinrank(coinrank, %{field: new_value})
      {:ok, %Coinrank{}}

      iex> update_coinrank(coinrank, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_coinrank(%Coinrank{} = coinrank, attrs) do
    coinrank
    |> Coinrank.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a coinrank.

  ## Examples

      iex> delete_coinrank(coinrank)
      {:ok, %Coinrank{}}

      iex> delete_coinrank(coinrank)
      {:error, %Ecto.Changeset{}}

  """
  def delete_coinrank(%Coinrank{} = coinrank) do
    Repo.delete(coinrank)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking coinrank changes.

  ## Examples

      iex> change_coinrank(coinrank)
      %Ecto.Changeset{data: %Coinrank{}}

  """
  def change_coinrank(%Coinrank{} = coinrank, attrs \\ %{}) do
    Coinrank.changeset(coinrank, attrs)
  end
end

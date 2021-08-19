defmodule Hodl.Portfolio.Coin do
  @behaviour Access
  use Ecto.Schema
  import Ecto.Changeset
  alias Hodl.Portfolio.Coin

  # To see what fetch is about:
  #https://elixirforum.com/t/ecto-schema-and-access-behaviour/12995/3
  #https://hexdocs.pm/elixir/Access.html#module-implementing-the-access-behaviour-for-custom-data-structures

  @derive {Jason.Encoder, only: [:name, :symbol, :uuid, :price_usd]}
  schema "coins" do
    field :name, :string
    field :symbol, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true
    field :coinmarketcap_id, :integer
    field :country_coin?, :boolean, default: false
    belongs_to :platform, Coin
    field :token_address, :string
    field :price_usd, :decimal, virtual: true
    timestamps()
  end

  def fetch(term, key) do
    term
    |> Map.from_struct()
    |> Map.fetch(key)
  end

  @doc false
  def changeset(coin, attrs) do
    coin
    |> cast(attrs, [:name, :symbol, :coinmarketcap_id, :platform_id, :token_address, :country_coin?])
    |> validate_required([:name, :symbol])
    |> foreign_key_constraint(:platform_id)
  end
end

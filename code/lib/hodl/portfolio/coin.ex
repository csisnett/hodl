defmodule Hodl.Portfolio.Coin do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hodl.Portfolio.Coin

  schema "coins" do
    field :name, :string
    field :symbol, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true
    field :coinmarketcap_id, :integer
    belongs_to :platform, Coin
    field :token_address, :string
    timestamps()
  end

  @doc false
  def changeset(coin, attrs) do
    coin
    |> cast(attrs, [:name, :symbol, :coinmarketcap_id, :platform_id, :token_address])
    |> validate_required([:name, :symbol, :coinmarketcap_id])
    |> foreign_key_constraint(:platform_id)
    |> unique_constraint(:coinmarketcap_id)
  end
end

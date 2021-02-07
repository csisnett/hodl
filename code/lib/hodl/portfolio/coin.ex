defmodule Hodl.Portfolio.Coin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "coins" do
    field :name, :string
    field :symbol, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true
    timestamps()
  end

  @doc false
  def changeset(coin, attrs) do
    coin
    |> cast(attrs, [:name, :symbol])
    |> validate_required([:name, :symbol])
  end
end

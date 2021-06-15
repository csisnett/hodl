defmodule Hodl.Portfolio.Quote do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hodl.Portfolio.Coin

  schema "quotes" do
    field :price_usd, :decimal

    belongs_to :coin, Coin
    timestamps()
  end

  @doc false
  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:price_usd, :coin_id])
    |> validate_required([:price_usd, :coin_id])
  end
end

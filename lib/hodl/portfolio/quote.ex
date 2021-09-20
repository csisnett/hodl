defmodule Hodl.Portfolio.Quote do
  @behaviour Access
  use Ecto.Schema
  import Ecto.Changeset
  alias Hodl.Portfolio.Coin

  @derive {Jason.Encoder, only: [:price_usd]}
  schema "quotes" do
    field :price_usd, :decimal

    belongs_to :coin, Coin
    timestamps()
  end

  def fetch(term, key) do
    term
    |> Map.from_struct()
    |> Map.fetch(key)
  end

  @doc false
  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:price_usd, :coin_id])
    |> validate_required([:price_usd, :coin_id])
  end
end

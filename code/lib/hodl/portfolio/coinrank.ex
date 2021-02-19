defmodule Hodl.Portfolio.Coinrank do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hold.Portfolio.{Coin, Ranking}

  schema "coinranks" do
    field :position, :integer
    belongs_to :coin, Coin
    belongs_to :ranking, Ranking
    timestamps()
  end

  @doc false
  def changeset(coinrank, attrs) do
    coinrank
    |> cast(attrs, [:position, :coin_id, :ranking_id])
    |> validate_required([:position, :coin_id, :ranking_id])
    |> foreign_key_constraint(:coin_id)
    |> foreign_key_constraint(:ranking_id)
 end
end

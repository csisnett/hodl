defmodule Hodl.Portfolio.Cycle do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hodl.Portfolio.{HodlSchedule, Coin, Cycle}

  schema "cycles" do
    field :price_per_coin, :decimal
    field :amount_of_coin, :decimal
    field :uuid, Ecto.ShortUUID, autogenerate: true
    field :first?, :boolean, default: false

    belongs_to :next_cycle, Cycle
    belongs_to :hodlschedule, HodlSchedule
    timestamps()
  end

  @doc false
  def changeset(cycle, attrs) do
    cycle
    |> cast(attrs, [:price_per_coin, :amount_of_coin, :first?, :hodlschedule_id, :next_cycle_id])
    |> validate_required([:price_per_coin, :amount_of_coin, :first?, :hodlschedule_id])
    |> foreign_key_constraint(:hodlschedule_id)
    |> foreign_key_constraint(:next_cycle_id)
  end
end

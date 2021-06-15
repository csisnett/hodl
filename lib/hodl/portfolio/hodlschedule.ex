defmodule Hodl.Portfolio.Hodlschedule do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hodl.Portfolio.{Coin}
  alias Hodl.Users.User

  schema "hodlschedules" do
    field :uuid, Ecto.ShortUUID, autogenerate: true
    belongs_to :user, User
    belongs_to :coin, Coin
    timestamps()
  end

  @doc false
  def changeset(hodlschedule, attrs) do
    hodlschedule
    |> cast(attrs, [:user_id, :coin_id])
    |> validate_required([:user_id, :coin_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:coin_id)
  end
end

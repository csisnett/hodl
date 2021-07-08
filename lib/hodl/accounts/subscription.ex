defmodule Hodl.Accounts.Subscription do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hodl.Accounts.{User, Plan}

  # Use user timezone in joined_, left_ timezones
  schema "subscriptions" do
    belongs_to :user, User
    belongs_to :plan, Plan

    field :joined_at, :naive_datetime
    field :joined_timezone, :string

    field :left_at, :naive_datetime 
    field :left_timezone, :string

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:user_id, :plan_id, :joined_at, :joined_timezone, :left_at, :left_timezone])
    |> validate_required([:user_id, :plan_id, :joined_at, :joined_timezone])
  end
end

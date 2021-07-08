defmodule Hodl.Accounts.Plan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plans" do
    field :description, :string
    field :email_limit, :integer
    field :name, :string
    field :sms_limit, :integer

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:name, :description, :email_limit, :sms_limit])
    |> validate_required([:name, :description, :email_limit, :sms_limit])
  end
end

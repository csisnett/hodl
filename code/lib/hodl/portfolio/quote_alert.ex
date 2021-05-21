defmodule Hodl.Portfolio.QuoteAlert do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hodl.Users.User
  alias Hodl.Portfolio.Coin

  schema "quotealerts" do
    field :uuid, Ecto.ShortUUID, autogenerate: true
    field :price_usd, :decimal
    field :email, :string
    field :active?, :boolean
    field :comparator, :string # "above" or "below"

    belongs_to :user, User
    belongs_to :coin, Coin
    timestamps()
  end

  def validate_comparator(changeset) do
    case get_field(changeset, :comparator) do
      "above" -> changeset
      "below" -> changeset
      anything_else -> add_error(changeset, :comparator, "comparator field is neither 'above' or 'below'")
    end
  end

  @doc false
  def changeset(quote_alert, attrs) do
    quote_alert
    |> cast(attrs, [:price_usd, :active?, :comparator, :user_id, :coin_id, :email])
    |> validate_required([:price_usd, :active?, :comparator, :user_id, :coin_id])
    |> validate_comparator()
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:coin_id)
  end
end

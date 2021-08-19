defmodule Hodl.Portfolio.QuoteAlert do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hodl.Users.User
  alias Hodl.Portfolio.{Coin, Quote}

  @attrs_to_cast [:price, :active?, :comparator, :user_id, :coin_id, :email, :trigger_quote_id, :deleted?, :base_coin_id, :percentage_target, :base_price]

  @derive {Jason.Encoder, only: [:active?, :comparator, :email, :uuid, :price, :coin_name, :coin_symbol]}
  schema "quotealerts" do
    field :uuid, Ecto.ShortUUID, autogenerate: true
    belongs_to :coin, Coin
    field :coin_name, :string, virtual: true
    field :coin_symbol, :string, virtual: true
    field :price, :decimal
    field :email, :string
    field :active?, :boolean, default: true
    field :deleted?, :boolean, default: false
    field :comparator, :string # "above" or "below"
    field :email_sent_datetime, :utc_datetime
    belongs_to :trigger_quote, Quote
    field :percentage_target, :decimal
    field :base_price, :decimal # For percentage comparisons
    belongs_to :base_coin, Coin
    belongs_to :user, User

    timestamps()
  end

  def adjust_comparator(changeset) do
    case get_field(changeset, :comparator) do
      "above" -> changeset
      "below" -> changeset
      "equal or greater than" -> put_change(changeset, :comparator, "above")
      "lower than" -> put_change(changeset, :comparator, "below")
      anything_else -> add_error(changeset, :comparator, "comparator field is neither 'equal or greater...' or 'lower than'")
    end
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
    |> cast(attrs, @attrs_to_cast)
    |> validate_required([:price, :active?, :comparator, :user_id, :coin_id, :deleted?, :base_coin_id])
    |> adjust_comparator()
    |> validate_comparator()
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:coin_id)
  end

  def delete_changeset(quote_alert, attrs) do
    quote_alert
    |> cast(attrs, [:price, :active?, :comparator, :user_id, :coin_id, :email, :trigger_quote_id, :deleted?])
    |> validate_required([:price, :active?, :comparator, :user_id, :coin_id, :deleted?])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:coin_id)
    |> foreign_key_constraint(:trigger_quote_id)
  end
end

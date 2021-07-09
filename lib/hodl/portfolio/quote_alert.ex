defmodule Hodl.Portfolio.QuoteAlert do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hodl.Users.User
  alias Hodl.Portfolio.{Coin, Quote}

   
  @derive {Jason.Encoder, only: [:active?, :comparator, :email, :uuid, :price_usd, :coin_name, :coin_symbol]}
  schema "quotealerts" do
    field :uuid, Ecto.ShortUUID, autogenerate: true
    field :price_usd, :decimal
    field :email, :string
    field :active?, :boolean, default: true
    field :deleted?, :boolean, default: false
    field :comparator, :string # "above" or "below"
    field :email_sent_datetime, :utc_datetime
    belongs_to :trigger_quote, Quote
    field :coin_name, :string, virtual: true
    field :coin_symbol, :string, virtual: true
    belongs_to :user, User
    belongs_to :coin, Coin
    timestamps()
  end

  def adjust_comparator(changeset) do
    case get_field(changeset, :comparator) do
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
    |> cast(attrs, [:price_usd, :active?, :comparator, :user_id, :coin_id, :email, :trigger_quote_id, :deleted?])
    |> validate_required([:price_usd, :active?, :comparator, :user_id, :coin_id, :deleted?])
    |> adjust_comparator()
    |> validate_comparator()
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:coin_id)
  end

  def delete_changeset(quote_alert, attrs) do
    quote_alert
    |> cast(attrs, [:price_usd, :active?, :comparator, :user_id, :coin_id, :email, :trigger_quote_id, :deleted?])
    |> validate_required([:price_usd, :active?, :comparator, :user_id, :coin_id, :deleted?])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:coin_id)
    |> foreign_key_constraint(:trigger_quote_id)
  end
end

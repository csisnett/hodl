defmodule Hodl.Portfolio.QuoteAlert do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hodl.Users.User
  alias Hodl.Portfolio.{Coin, Quote}

  @attrs_to_cast [:coin_id, :above_price, :below_price, :email, :phone_number,
  :finished?, :deleted?, :email_sent_datetime, :sms_sent_datetime, :above_percentage,
  :below_percentage, :base_price, :base_coin_id, :user_id]

  @attrs_to_send [:finished?, :email, :uuid, :above_price, :below_price,
   :above_percentage, :below_percentage, :base_price, :coin_name, :coin_symbol]

  @derive {Jason.Encoder, only: @attrs_to_send}
  schema "quotealerts" do
    field :uuid, Ecto.ShortUUID, autogenerate: true
    belongs_to :coin, Coin
    field :coin_name, :string, virtual: true
    field :coin_symbol, :string, virtual: true
    field :above_price, :decimal
    field :below_price, :decimal
    field :email, :string
    field :phone_number, :string
    field :deleted?, :boolean, default: false
    field :finished?, :boolean, default: false
    field :user_editable?, :boolean, virtual: true
    field :email_sent_datetime, :utc_datetime
    field :sms_sent_datetime, :utc_datetime
    field :above_percentage, :decimal
    field :below_percentage, :decimal
    field :base_price, :decimal # For percentage comparisons
    belongs_to :base_coin, Coin
    belongs_to :user, User

    timestamps()
  end

  def maybe_require_base_price(changeset) do
    above_percentage = get_field(changeset, :above_percentage)
    below_percentage = get_field(changeset, :below_percentage)
    percentage_alert? = if above_percentage != nil or below_percentage != nil do true else false end
    base_price = get_field(changeset, :base_price)

    if percentage_alert? and base_price == nil do
      add_error(changeset, :base_price, "You must have a base price for a percentage alert")
    else
      changeset
    end
  end

  def cant_be_price_and_percentage(changeset) do
    above_price = get_field(changeset, :above_price) # If there's no above price it defaults to nil
    below_price = get_field(changeset, :below_price) # same
    above_percentage = get_field(changeset, :above_percentage)
    below_percentage = get_field(changeset, :below_percentage)

    price_alert? = if above_price != nil or below_price != nil do true else false end

    percentage_alert? = if above_percentage != nil or below_percentage != nil do true else false end

    if price_alert? and percentage_alert? do
      add_error(changeset, :above_price, "It must be either a price or a percentage alert not both", [:above_price, :below_price, :above_percentage, :below_percentage])
    else
      changeset
    end
  end

  def require_price_or_percentage(changeset) do
    above_price = get_field(changeset, :above_price) # If there's no above price it defaults to nil
    below_price = get_field(changeset, :below_price) # same
    above_percentage = get_field(changeset, :above_percentage)
    below_percentage = get_field(changeset, :below_percentage)

    # If all these fields are nil add an error
    if above_price == below_price and above_price == above_percentage and above_percentage == below_percentage do
      add_error(changeset, :above_price, "There's no price or percentage value for the quote alert", [:above_price, :below_price, :above_percentage, :below_percentage])
    else
      changeset
    end
  end

  @doc false
  def changeset(quote_alert, attrs) do
    quote_alert
    |> cast(attrs, @attrs_to_cast)
    |> validate_required([:user_id, :coin_id, :deleted?, :finished?, :base_coin_id])
    |> require_price_or_percentage()
    |> cant_be_price_and_percentage()
    |> maybe_require_base_price()
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:coin_id)
  end
end

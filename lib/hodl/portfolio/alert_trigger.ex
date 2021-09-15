defmodule Hodl.Portfolio.AlertTrigger do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hodl.Portfolio.{Quote, QuoteAlert}

  schema "alerttriggers" do
    field :uuid, Ecto.ShortUUID, autogenerate: true
    field :type, :string # above_price below_price above_percentage, etc
    field :email_address, :string
    field :phone_number, :string
    field :email_sent_datetime, :utc_datetime
    field :sms_sent_datetime, :utc_datetime
    field :message, :string, virtual: true

    belongs_to :quote_alert, QuoteAlert
    belongs_to :quote, Quote

    timestamps()
  end

  @doc false
  def changeset(alert_trigger, attrs) do
    alert_trigger
    |> cast(attrs, [:type, :quote_alert_id, :quote_id, :phone_number, :email_address, :email_sent_datetime, :sms_sent_datetime])
    |> validate_required([:type, :quote_alert_id, :quote_id])
    |> foreign_key_constraint(:quote_alert_id)
    |> foreign_key_constraint(:quote_id)
  end
end

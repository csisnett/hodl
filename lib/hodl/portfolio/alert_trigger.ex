defmodule Hodl.Portfolio.AlertTrigger do
  use Ecto.Schema
  import Ecto.Changeset

  schema "alerttriggers" do
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(alert_trigger, attrs) do
    alert_trigger
    |> cast(attrs, [:type])
    |> validate_required([:type])
  end
end

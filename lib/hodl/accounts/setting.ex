defmodule Hodl.Accounts.Setting do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hodl.Users.User

  @valid_setting_keys ["timezone", "admin"]

  schema "settings" do
    field :setting_key, :string
    field :value, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true

    belongs_to :user, User
    timestamps()
  end

  def validate_setting_key(changeset) do
    {_, setting_key} = fetch_field(changeset, :setting_key)
    case Enum.member?(@valid_setting_keys, setting_key) do
      true -> changeset
      false -> add_error(changeset, :setting_key, "Not a valid setting key")
    end
  end


  @doc false
  def changeset(setting, attrs) do
    setting
    |> cast(attrs, [:setting_key, :value, :user_id])
    |> validate_required([:setting_key, :value, :user_id])
    |> validate_setting_key
    |> foreign_key_constraint(:user_id)
  end
end

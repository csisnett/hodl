defmodule Hodl.Repo.Migrations.ModifyQuoteAlertAddPercentage do
  use Ecto.Migration

  def up do
    alter table(:quotealerts) do
      add :below_price, :decimal
      add :above_percentage, :decimal
      add :below_percentage, :decimal
      add :base_price, :decimal
      add :base_coin_id, references(:coins, on_delete: :delete_all), null: false
      add :phone_number, :string
      add :sms_sent_datetime, :utc_datetime
      add :finished?, :boolean, null: false
      remove :active?
      remove :price_usd
    end
  end

  def down do
    alter table(:quotealerts) do
        remove :below_price
        remove :above_percentage
        remove :below_percentage
        remove :base_price
        remove :base_coin_id
        remove :phone_number
        remove :sms_sent_datetime
        remove :finished?
        add :active?, :boolean
        add :price_usd, :decimal
    end
  end
end

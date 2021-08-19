defmodule Hodl.Repo.Migrations.ModifyQuoteAlertAddPercentage do
  use Ecto.Migration

  def change do
    alter table(:quotealerts) do
      add :percentage_target, :decimal
      add :base_price, :decimal
      add :base_coin_id, references(:coins, on_delete: :delete_all), null: false
    end
    rename table(:quotealerts), :price_usd, to: :price
  end
end

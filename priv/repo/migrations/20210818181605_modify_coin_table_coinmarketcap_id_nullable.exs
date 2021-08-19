defmodule Hodl.Repo.Migrations.ModifyCoinTableCoinmarketcapIdNullable do
  use Ecto.Migration

    def up do
      alter table(:coins) do
        modify :coinmarketcap_id, :integer, null: true
        add :country_coin?, :boolean, default: false
      end
    end

    def down do
      alter table(:coins) do
        modify :coinmarketcap_id, :integer, null: false
      end
    end

end

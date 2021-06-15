defmodule Hodl.Repo.Migrations.ModifyCoinsAddCoinmarketcapId do
  use Ecto.Migration

  def change do
    alter table(:coins) do
      add :coinmarketcap_id, :integer, null: false
      add :token_address, :string
      add :platform_id, references(:coins, on_delete: :nothing) 
    end
    create unique_index(:coins, [:coinmarketcap_id])
  end
end

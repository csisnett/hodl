defmodule Hodl.Repo.Migrations.CreateCycles do
  use Ecto.Migration

  def change do
    create table(:cycles) do
      add :price_per_coin, :decimal, null: false
      add :amount_of_coin, :decimal, null: false
      add :uuid, :uuid, null: false
      add :first?, :boolean, null: false

      add :hodlschedule_id, references(:hodlschedules, on_delete: :delete_all), null: false
      timestamps()
    end
    create index(:cycles, [:hodlschedule_id])
  end
end

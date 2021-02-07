defmodule Hodl.Repo.Migrations.CreateHodlschedules do
  use Ecto.Migration

  def change do
    create table(:hodlschedules) do
      add :initial_coin_price, :decimal
      add :initial_coin_amount, :decimal
      add :uuid, :uuid, null: false

      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :coin_id, references(:coins, on_delete: :delete_all), null: false
      timestamps()
    end
    create index(:hodlschedules, [:user_id])
    create index(:hodlschedules, [:coin_id])
    create unique_index(:hodlschedules, [:uuid])
  end
end

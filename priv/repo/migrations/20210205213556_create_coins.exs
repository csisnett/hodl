defmodule Hodl.Repo.Migrations.CreateCoins do
  use Ecto.Migration

  def change do
    create table(:coins) do
      add :name, :string, null: false
      add :symbol, :string, null: false
      add :uuid, :uuid, null: false

      timestamps()
    end
    create unique_index(:coins, [:uuid])
  end
end

defmodule Hodl.Repo.Migrations.CreateQuotes do
  use Ecto.Migration

  def change do
    create table(:quotes) do
      add :price_usd, :decimal, null: false
      add :coin_id, references(:coins, on_delete: :delete_all), null: false
      timestamps()
    end
    create index(:quotes, [:coin_id])
  end
end

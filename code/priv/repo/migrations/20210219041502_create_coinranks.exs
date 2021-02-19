defmodule Hodl.Repo.Migrations.CreateCoinranks do
  use Ecto.Migration

  def change do
    create table(:coinranks) do
      add :position, :integer, null: false
      add :coin_id, references(:coins, on_delete: :delete_all), null: false
      add :ranking_id, references(:rankings, on_delete: :delete_all), null: false
      timestamps()
    end
    create unique_index(:coinranks, [:coin_id, :ranking_id, :position])
  end
end

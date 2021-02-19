defmodule Hodl.Repo.Migrations.CreateRankings do
  use Ecto.Migration

  def change do
    create table(:rankings) do
      add :name, :string, null: false
      add :uuid, :uuid, null: false
      add :slug, :string, null: false
      timestamps()
    end
    create unique_index(:rankings, [:uuid])
    create unique_index(:rankings, [:slug])
  end
end

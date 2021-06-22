defmodule Hodl.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :setting_key, :string, null: false
      add :value, :string, null: false
      add :uuid, :uuid, null: false

      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end
    create index(:settings, [:user_id])
    create unique_index(:settings, [:uuid])
    create unique_index(:settings, [:user_id, :setting_key])

  end
end

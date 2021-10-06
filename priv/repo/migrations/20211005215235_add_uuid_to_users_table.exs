defmodule Hodl.Repo.Migrations.AddUuidToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :uuid, :uuid, null: false
    end
    create unique_index(:users, [:uuid])
  end
end

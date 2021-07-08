defmodule Hodl.Repo.Migrations.ModifyUserTableRole do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :string, default: "regular", null: false
    end
  end
end

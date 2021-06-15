defmodule Hodl.Repo.Migrations.ModifyCycleAddNextCycle do
  use Ecto.Migration

  def change do
    alter table(:cycles) do
      add :next_cycle_id, references(:cycles, on_delete: :nothing)
    end
  end
end

defmodule Hodl.Repo.Migrations.ModifyCycleTableAddPercentageSale do
  use Ecto.Migration

  def change do
    alter table(:cycles) do
      add :sale_percentage, :decimal, null: false
    end
  end
end

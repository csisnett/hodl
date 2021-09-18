defmodule Hodl.Repo.Migrations.AddActiveToQuoteAlertTable do
  use Ecto.Migration

  def change do
    alter table(:quotealerts) do
      add :active, :string, null: false
      remove :finished?
    end
  end
end

defmodule Hodl.Repo.Migrations.ModifyQuoteAlertAddTriggerTimeTriggerPrice do
  use Ecto.Migration

  def change do
    alter table(:quotealerts) do
      add :trigger_quote_id, references(:quotes, on_delete: :delete_all)
    end
    create index(:quotealerts, [:trigger_quote_id])
  end
end

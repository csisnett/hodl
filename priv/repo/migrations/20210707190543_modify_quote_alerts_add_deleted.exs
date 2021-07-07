defmodule Hodl.Repo.Migrations.ModifyQuoteAlertsAddDeleted do
  use Ecto.Migration

  def change do
    alter table(:quotealerts) do
      add :deleted?, :boolean, default: false, null: false
    end
  end

end

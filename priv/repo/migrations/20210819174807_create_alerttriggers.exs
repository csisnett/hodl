defmodule Hodl.Repo.Migrations.CreateAlerttriggers do
  use Ecto.Migration

  def change do
    create table(:alerttriggers) do
      add :type, :string, null: false
      add :quote_id, references(:quotes, on_delete: :delete_all), null: false
      add :quote_alert_id, references(:quotealerts, on_delete: :delete_all), null: false
      add :basequote_id, references(:quotes, on_delete: :delete_all)
      timestamps()

    end
    create index(:alerttriggers, [:quote_alert_id])
  end
end

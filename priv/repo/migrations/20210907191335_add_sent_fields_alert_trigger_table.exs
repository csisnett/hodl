defmodule Hodl.Repo.Migrations.AddSentFieldsAlertTriggerTable do
  use Ecto.Migration

  def up do
    alter table(:alerttriggers) do
      add :email_sent_datetime, :utc_datetime
      add :email_address, :string
      add :phone_number, :string
      add :sms_sent_datetime, :utc_datetime
      add :uuid, :uuid, null: false
    end
    create unique_index(:alerttriggers, [:uuid])
  end

  def down do
      alter table(:alerttriggers) do
        remove :email_sent_datetime, :utc_datetime
        remove :email_address, :string
        remove :phone_number, :string
        remove :sms_sent_datetime, :utc_datetime
      end

      alter table(:quotealerts) do
        add :email_sent_datetime, :utc_datetime
        add :sms_sent_datetime, :utc_datetime
      end
  end
end

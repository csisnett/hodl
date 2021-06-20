defmodule Hodl.Repo.Migrations.ModifyQuotealertsAddEmailSentdatetime do
  use Ecto.Migration

  def change do
      alter table(:quotealerts) do
        add :email_sent_datetime, :utc_datetime
      end
  end
end

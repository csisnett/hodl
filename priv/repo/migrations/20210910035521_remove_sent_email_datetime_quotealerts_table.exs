defmodule Hodl.Repo.Migrations.RemoveSentEmailDatetimeQuotealertsTable do
  use Ecto.Migration

  def change do
    alter table(:quotealerts) do
      remove :email_sent_datetime, :utc_datetime
    end
  end
end

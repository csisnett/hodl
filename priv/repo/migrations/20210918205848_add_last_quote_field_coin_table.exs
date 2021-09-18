defmodule Hodl.Repo.Migrations.AddLastQuoteFieldCoinTable do
  use Ecto.Migration

  def change do
    alter table(:coins) do
      add :last_quote_id, references(:quotes)
    end
  end
end

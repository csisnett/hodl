defmodule Hodl.Repo.Migrations.AddAbovePriceQuotealertsTable do
  use Ecto.Migration

  def change do
    alter table(:quotealerts) do
      add :above_price, :decimal
    end
  end
end

defmodule Hodl.Repo.Migrations.DeleteComparatorFieldQuoteAlertTable do
  use Ecto.Migration

  def change do
    alter table(:quotealerts) do
      remove_if_exists :comparator, :string
    end
  end
end

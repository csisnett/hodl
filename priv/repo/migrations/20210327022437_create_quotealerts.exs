defmodule Hodl.Repo.Migrations.CreateQuotealerts do
  use Ecto.Migration

  def change do
    create table(:quotealerts) do
      add :uuid, :uuid, null: false
      add :price_usd, :decimal, null: false
      add :email, :string
      add :active?, :boolean, null: false
      add :comparator, :string, null: false

      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :coin_id, references(:coins, on_delete: :delete_all), null: false
      timestamps()
    end
    create unique_index(:quotealerts, [:uuid])
  end
end

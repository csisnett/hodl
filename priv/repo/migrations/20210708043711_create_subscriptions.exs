defmodule Hodl.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :plan_id, references(:plans, on_delete: :delete_all), null: false
      add :joined_at, :naive_datetime, null: false
      add :joined_timezone, :string, null: false

      add :left_at, :naive_datetime
      add :left_timezone, :string
      timestamps()
    end

  end
end

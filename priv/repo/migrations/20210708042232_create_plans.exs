defmodule Hodl.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add :name, :string, null: false
      add :description, :string
      add :email_limit, :integer, null: false
      add :sms_limit, :integer, null: false

      timestamps()
    end

  end
end

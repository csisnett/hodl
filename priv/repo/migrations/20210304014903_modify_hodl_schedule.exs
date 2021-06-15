defmodule Hodl.Repo.Migrations.ModifyHodlSchedule do
  use Ecto.Migration

  def change do
    alter table(:hodlschedules) do
      remove :initial_coin_price
      remove :initial_coin_amount
    end
  end
end

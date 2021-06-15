defmodule Hodl.Repo do
  use Ecto.Repo,
    otp_app: :hodl,
    adapter: Ecto.Adapters.Postgres

    def init(_type, config) do
      {:ok, Keyword.put(config, :url, System.get_env("HODL_DATABASE_URL"))}
    end
end

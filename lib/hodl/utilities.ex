defmodule Hodl.Utilities do
    import Ecto.Query, warn: false

    def database_size() do
        Ecto.Adapters.SQL.query!(
         Hodl.Repo, "SELECT pg_size_pretty( pg_database_size('hodl_dev'))"
    )
    end

    def table_size(name) do
        Ecto.Adapters.SQL.query!(
         Hodl.Repo, "SELECT pg_size_pretty( pg_total_relation_size('#{name}'))"
    )
    end

end
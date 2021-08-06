defmodule Hodl.MinuteWorker do
    alias Hodl.Portfolio
    use Oban.Worker,
      queue: :repetitive,
      priority: 1,
      tags: ["business"],
      unique: [fields: [:queue, :worker]]

    @impl Oban.Worker
    def perform(job) do
      case Application.fetch_env!(:hodl, :development) do
        "false" ->
          IO.inspect(DateTime.utc_now())
          Portfolio.initiate_quote_retrieval()

        "true" -> IO.inspect("Not getting quotes in dev env")
      end
      :ok
    end
  end

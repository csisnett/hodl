defmodule Hodl.MinuteWorker do
    alias Hodl.Portfolio
    use Oban.Worker,
      queue: :repetitive,
      priority: 1,
      max_attempts: 10,
      tags: ["business"],
      unique: [period: 30]
  
    @impl Oban.Worker
    def perform(%Oban.Job{attempt: attempt}) when attempt > 3 do

      message = "This is attempt # #{attempt}!"
      IO.inspect(message)
      IO.inspect(DateTime.utc_now())

      Portfolio.initiate_quote_retrieval()

      :ok
    end
  
    def perform(job) do
      IO.inspect(DateTime.utc_now())
      Portfolio.initiate_quote_retrieval()

      :ok
    end
  end
defmodule Hodl.Portfolio.QuoteWorker do
    use Oban.Worker, queue: :events, max_attempts: 3
    alias Hodl.Portfolio
    
    @impl Oban.Worker
    def perform(%Oban.Job{args: %{"name" => "get_top_quotes"}}) do

      Portfolio.get_top_quotes() |> Portfolio.create_new_quotes()
      :ok
    end
  end
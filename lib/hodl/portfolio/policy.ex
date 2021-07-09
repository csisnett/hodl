defmodule Hodl.Portfolio.Policy do
    @behaviour Bodyguard.Policy

    alias Hodl.Users.User
    alias Hodl.Portfolio.{Coin, Coinrank, Cycle, Hodlschedule, QuoteAlert, Quote, Ranking}

    #For Alerts

    def authorize(action, %User{}, attrs) when action in [:create_alert] do
        true
    end
    
    # authorize users to edit and soft delete only their own alerts when they don't haven't been triggered
    def authorize(action, %User{id: user_id}, %QuoteAlert{user_id: user_id, trigger_quote_id: nil} = quote_alert) when action in [:update_quote_alert, :soft_delete_quote_alert] do
        true
    end

    

    # Admin can do anything
    def authorize(action, %User{role: "admin"}, _) do
        true
    end

    #Deny every other scenario
    def authorize(_,_,_) do
        false
    end

end
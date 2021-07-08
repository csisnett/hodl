defmodule Hodl.Accounts.Policy do

    alias Hodl.Accounts.{Plan, Setting, Subscription}
    alias Hodl.Users.User
    @behaviour Bodyguard.Policy
    alias __MODULE__
  
    # Admin users can do anything
    def authorize(_, %User{username: "dbennett"}, _), do: true
  
    # Regular users can create posts
    def authorize(:create_post, _, _), do: true
  
    # Regular users can modify their own posts
    def authorize(action, %User{id: user_id}, %Setting{user_id: user_id})
      when action in [:update_post, :delete_post], do: true
  
    # Catch-all: deny everything else
    def authorize(_, _, _), do: false

end
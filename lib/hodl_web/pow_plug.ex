defmodule HodlWeb.Pow.Plug do
    alias Hodl.Users.User

    use Pow.Plug.Base
  
    @session_key :pow_user_token
    @salt "8ArmkGZe/b4Qj+PRgSokuor90wVPyn//yjJaStfPQFbZrE0lhZ2ViZDO7HGvyr5o"
    @max_age 5184000 #60 days
  
    def fetch(conn, config) do
      conn  = Plug.Conn.fetch_session(conn)
      token = Plug.Conn.get_session(conn, @session_key)
  
      HodlWeb.Endpoint
      |> Phoenix.Token.verify(@salt, token, max_age: @max_age)
      |> maybe_load_user(conn)
    end
  
    defp maybe_load_user({:ok, user_id}, conn), do: {conn, Hodl.Repo.get(User, user_id)}
    defp maybe_load_user({:error, _any}, conn), do: {conn, nil}
  
    def create(conn, user, config) do
      token = Phoenix.Token.sign(HodlWeb.Endpoint, @salt, user.id)
      conn  = 
        conn
        |> Plug.Conn.fetch_session()
        |> Plug.Conn.put_session(@session_key, token)
  
      {conn, user}
    end

    # %Conn{}, %User{} -> %Conn{}
    def sign_in_user_from_server(conn, user) do
      token = Phoenix.Token.sign(HodlWeb.Endpoint, @salt, user.id)

        conn
        |> Plug.Conn.fetch_session()
        |> Plug.Conn.put_session(@session_key, token)
    end
  
    def delete(conn, config) do
      conn
      |> Plug.Conn.fetch_session()
      |> Plug.Conn.delete_session(@session_key)
    end
  end
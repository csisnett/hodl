defmodule HodlWeb.Pow.Mailer do
    use Pow.Phoenix.Mailer
    use Swoosh.Mailer, otp_app: :pow

    alias Hodl.Users.User
    import Swoosh.Email

    require Logger

    @impl true
    def cast(%{user: user, subject: subject, text: text, html: html}) do
      %Swoosh.Email{}
      |> to({user.username, user.email})
      |> from({"Daniel from Howtohodl.org", "daniel@howtohodl.org"})
      |> subject(subject)
      |> html_body(html)
      |> text_body(text)
    end
  
    @impl true
    def process(email) do
      # An asynchronous process should be used here to prevent enumeration
      # attacks. Synchronous e-mail delivery can reveal whether a user already
      # exists in the system or not.
  
      Task.start(fn ->
        email
        |> deliver()
        |> log_warnings()
      end)
  
      :ok
    end
  
    defp log_warnings({:error, reason}) do
      Logger.warn("Mailer backend failed with: #{inspect(reason)}")
    end
  
    defp log_warnings({:ok, response}), do: {:ok, response}
  end
defmodule HodlWeb.PowResetPassword.MailerView do
  use HodlWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end

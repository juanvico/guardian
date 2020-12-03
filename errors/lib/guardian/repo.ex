defmodule Guardian.Repo do
  use Ecto.Repo,
    otp_app: :guardian,
    adapter: Ecto.Adapters.Postgres
end

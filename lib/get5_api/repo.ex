defmodule Get5Api.Repo do
  use Ecto.Repo,
    otp_app: :get5_api,
    adapter: Ecto.Adapters.Postgres
end

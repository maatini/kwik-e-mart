defmodule KwikEMart.Repo do
  use Ecto.Repo,
    otp_app: :kwik_e_mart,
    adapter: Ecto.Adapters.Postgres
end

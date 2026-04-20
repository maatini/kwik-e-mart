ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(KwikEMart.Repo, :manual)
# Preload test support modules before ExUnit compiles test files in parallel.
# Without this, parallel compilation races cause "module not loaded" errors.
Code.ensure_loaded!(KwikEMart.DataCase)
Code.ensure_loaded!(KwikEMartWeb.ConnCase)

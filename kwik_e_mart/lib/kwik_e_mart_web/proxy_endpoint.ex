defmodule KwikEMartWeb.ProxyEndpoint do
  use Beacon.ProxyEndpoint,
    otp_app: :kwik_e_mart,
    session_options: Application.compile_env!(:kwik_e_mart, :session_options),
    fallback: KwikEMartWeb.Endpoint
end

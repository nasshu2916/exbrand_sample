defmodule ExbrandSampleWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :exbrand_sample

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_exbrand_sample_key",
    signing_salt: "gsp7CrVR",
    same_site: "Lax"
  ]

  plug Plug.Static,
    at: "/",
    from: :exbrand_sample,
    gzip: not code_reloading?,
    only: ExbrandSampleWeb.static_paths(),
    raise_on_missing_only: code_reloading?

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :exbrand_sample
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug ExbrandSampleWeb.Router
end

defmodule EsprezzoCoreWeb.Endpoint do
  require IEx
  use Phoenix.Endpoint, otp_app: :esprezzo_core
  require Logger

  socket "/socket", EsprezzoCoreWeb.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :esprezzo_core, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_esprezzo_core_key",
    signing_salt: "uPQn09w4"

  plug EsprezzoCoreWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      #port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      port = System.get_env("PORT") [30342]
      Logger.warn "USING ENV CONFIG"
      Logger.warn "#{port}"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      Logger.warn "USING APP CONFIG"
      {:ok, config}
    end
  end
end

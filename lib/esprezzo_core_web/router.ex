defmodule EsprezzoCoreWeb.Router do
  use EsprezzoCoreWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EsprezzoCoreWeb do
    pipe_through :api
    get  "/blocks", BlockController, :index
    get  "/blocks/:hash", BlockController, :show
    get  "/transactions", BlockController, :txns
    get  "/status", StatusController, :index
    get  "/ping", StatusController, :ping
  end
end

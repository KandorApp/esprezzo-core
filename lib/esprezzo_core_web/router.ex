defmodule EsprezzoCoreWeb.Router do
  use EsprezzoCoreWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EsprezzoCoreWeb do
    pipe_through :api
  end
end

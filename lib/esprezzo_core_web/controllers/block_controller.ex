defmodule EsprezzoCoreWeb.BlockController do
  use EsprezzoCoreWeb, :controller
  require IEx

  alias EsprezzoCore.PeerNet
  alias EsprezzoCore.Blockchain

  plug :put_layout, false

  def index(conn, params) do
    page = case params["page"] do
      nil -> 1
      p when is_integer(p) -> p
      p -> 
        {n, _} = Integer.parse(p)
        n
    end

    limit = case params["limit"] do
      nil -> 10
      l when is_integer(l) -> l
      l -> 
        {n, _} = Integer.parse(l)
        n
    end

    start = case page do
      1 -> 0
      n -> (n - 1) * limit
    end
    page = Blockchain.get_blocks(start, limit)

    conn
    |> put_status(:ok)
    |> json %{blocks: page}
  end
end

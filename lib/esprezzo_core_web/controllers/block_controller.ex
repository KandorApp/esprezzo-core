defmodule EsprezzoCoreWeb.BlockController do
  use EsprezzoCoreWeb, :controller

  alias EsprezzoCore.PeerNet
  alias EsprezzoCore.Blockchain

  plug :put_layout, false


  def index(conn, _params) do
    start = 0
    count = 5
    page = Blockchain.get_blocks(start, count)
        
    blocks = %{
    
    }
    conn
    |> put_status(:ok)
    |> json %{blocks: blocks}
  end
end

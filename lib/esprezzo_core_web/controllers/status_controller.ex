defmodule EsprezzoCoreWeb.StatusController do
  use EsprezzoCoreWeb, :controller
  require IEx

  alias EsprezzoCore.PeerNet
  alias EsprezzoCore.Blockchain

  plug :put_layout, false

  def index(conn, _params) do
    
    s = PeerNet.local_node_uuid

    latest_block = Blockchain.latest_block_overview()
        
    status = %{
      node_uuid: PeerNet.local_node_uuid(),
      height: Blockchain.current_height(),
      last_block_hash: latest_block.header_hash,
      last_block_time: latest_block.timestamp,
      last_block_txn_count: latest_block.txn_count
    }
    conn
    |> put_status(:ok)
    |> json %{status: status}
  end

  def ping(conn, _params) do
    conn
    |> put_status(:ok)
    |> json "pong"
  end

end

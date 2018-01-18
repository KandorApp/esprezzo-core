defmodule EsprezzoCore.Command do
  use GenServer
  require Logger
  alias EsprezzoCore.PeerNet

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end
 
  @doc"""
  Initialize Command Worker
  callbacks
  """
  def init(opts) do
    PeerNet.bootstrap_connections()
    PeerNet.peers()
    Logger.warn(fn -> 
      "Connected to #{EsprezzoCore.PeerNet.count_peers} peers"
    end)
    {:ok, []}
  end

end
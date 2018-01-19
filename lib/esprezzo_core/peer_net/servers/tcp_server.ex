defmodule EsprezzoCore.PeerNet.TCPServer do
  
  require Logger
  require IEx
  use GenServer
  alias EsprezzoCore.PeerNet.TCPHandler
  alias EsprezzoCore.PeerNet
  
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc"""
  Setup p2p tcp listener
  Takes list of 2-tuples for input params
  """
  def init(opts) do
    tcp_opts = [{:port, Keyword.get(opts, :port)}]
    {:ok, pid} = :ranch.start_listener(:network, 100, :ranch_tcp, tcp_opts, TCPHandler, [])
    Logger.info(fn ->
      "Listening for connections on port #{Keyword.get(opts, :port)}"
    end)
    #PeerNet.bootstrap_connections()
    {:ok, pid}
  end

end
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
  """
  def init(opts) do
    tcp_opts = [{:port, Keyword.get(opts, :port)}]
    node_uuid = Keyword.get(opts, :node_uuid)
    {:ok, pid} = :ranch.start_listener(:network, 100, :ranch_tcp, tcp_opts, TCPHandler, [{:node_uuid, node_uuid}])
    Logger.info(fn ->
      "Listening for connections on port #{Keyword.get(opts, :port)}"
    end)
    
    {:ok, %{pid: pid, node_uuid: node_uuid}}
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state, :infinity)
  end
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
end
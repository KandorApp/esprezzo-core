defmodule EsprezzoCore.PeerNet.PeerManager do
  @moduledoc"""
  Genserver container that aggregates and exposes 
  data from all peer connections.
  """

  use GenServer
  require Logger
  alias EsprezzoCore.PeerNet
  alias EsprezzoCore.PeerNet.PeerTracker
  alias EsprezzoCore.PeerNet.WireProtocol
  @doc"""
  Setup
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc"""
  Initialize PeerManager Process
  %{
    :connected_peers => [],
    :authorized_peers => [],
    :node_uuid => String.t
  }
  """
  def init(opts) do
    PeerNet.bootstrap_connections()
    connected_peers = __MODULE__.refresh_peer_data()
    Logger.warn(fn -> 
      inspect opts
      "Connected to #{EsprezzoCore.PeerNet.count_peers} peers"
    end)
    {:ok, %{
      :authorized_peers => [],
      :connected_peers => connected_peers,
      :node_uuid => WireProtocol.generate_node_uuid
      }
    }
  end

  @doc"""
  Convenient way to get a List of all peer nodes

  Example: 

    iex> EsprezzoCore.PeerNet.PeerManager.get_state
  
    %{peers: [
      %{remote_addr: "40.65.113.90", remote_port: 30343,socket: #Port<0.8355>, transport: :gen_tcp},
      %{remote_addr: "52.169.4.140", remote_port: 30343, socket: #Port<0.8390>,transport: :gen_tcp}
      ]
    }

  """
  def get_state do
    GenServer.call(__MODULE__, :get_state, :infinity)
  end

  @doc"""
  Collect all data from all peers to
  local state. Used on init.
  """
  def refresh_peer_data do
    PeerTracker.list_peers()
      |> Enum.map(fn pid -> 
        EsprezzoCore.PeerNet.Peer.peer_state(pid)
      end)
  end

  # various process messages

  @doc"""
  Return state. Not used directly. 
  Used through module __MODULE__.get_state wrapper.
  
  Example:

    iex> EsprezzoCore.PeerNet.PeerManager.get_state

  """
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

end
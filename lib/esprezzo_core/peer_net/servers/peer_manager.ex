defmodule EsprezzoCore.PeerNet.PeerManager do
  @moduledoc """
  Genserver container that aggregates and exposes 
  data from all peer connections.
  """

  use GenServer
  require Logger
  require IEx
  alias EsprezzoCore.PeerNet
  alias EsprezzoCore.PeerNet.PeerTracker
  @doc """
  Setup
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Initialize PeerManager Process
  %{
    :connected_peers => [],
    :authorized_peers => [],
    :node_uuid => String.t
  }
  """
  def init(opts) do
    PeerNet.bootstrap_connections(opts.node_uuid)
    connected_peers = __MODULE__.refresh_peer_data()
    Logger.warn(fn ->
      "Connected to #{EsprezzoCore.PeerNet.count_peers} peers"
    end)
    {:ok, %{
      :authorized_peers => [],
      :connected_peers => connected_peers,
      :node_uuid => opts.node_uuid
      }
    }
  end

  @doc """
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
    # various process messages

  @doc """
  Return state. Not used directly. 
  Used through module __MODULE__.get_state wrapper.
  
  Example:

    iex> EsprezzoCore.PeerNet.PeerManager.get_state

  """
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @doc """
    iex> EsprezzoCore.PeerNet.PeerManager.notify_peers_with_new_block(block)
  """
  def notify_peers_with_new_block(block) do
    GenServer.call(__MODULE__, {:notify_peers_with_new_block, block}, :infinity)
  end
  def handle_call({:notify_peers_with_new_block, block}, _from, state) do
    state.connected_peers
    |> Enum.each(fn p -> 
      Logger.warn "Notifying Peer #{p.remote_addr} // #{p.node_uuid} with new block #{block.header_hash}"
      EsprezzoCore.PeerNet.Peer.push_block(p.pid, block)
    end)
    {:reply, state, state}
  end


  @doc """
  Collect all data from all peers to
  local state. Used on init.
  """
  def refresh_peer_data do
    PeerTracker.list_peer_pids()
      |> Enum.map(fn pid -> 
        EsprezzoCore.PeerNet.Peer.peer_state(pid)
      end)
  end



end
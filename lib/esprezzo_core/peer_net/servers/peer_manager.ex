defmodule EsprezzoCore.PeerNet.PeerManager do
  @moduledoc """
  Genserver container that aggregates and exposes 
  data from all peer connections.

  This exists to hold data as opposed to being
  the Supervisor as seen in PeerSupervisor.

  This library accesses the Supervisor and is the 
  main data repo for peer connections
  """
  use GenServer
  require Logger
  require IEx
  alias EsprezzoCore.PeerNet
  alias EsprezzoCore.PeerNet.PeerSupervisor
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
    #schedule_restart_peer_connections()
    schedule_maintain_peer_connections()
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
    iex> EsprezzoCore.PeerNet.PeerManager.restart_peer_connections()
  """
  def restart_peer_connections() do
    GenServer.call(__MODULE__, :restart_peer_connections, :infinity)
  end
  def handle_call(:restart_peer_connections, _from, state) do
    destroy_peer_data()
    PeerNet.bootstrap_connections(state.node_uuid)
    connected_peers = __MODULE__.refresh_peer_data()
    Logger.warn(fn ->
      "Connected to #{EsprezzoCore.PeerNet.count_peers} peers"
    end)
    {:ok, %{
      :authorized_peers => [],
      :connected_peers => connected_peers,
      :node_uuid => state.node_uuid
      }
    }
    schedule_restart_peer_connections()
    {:reply, state, state}
  end
  def handle_info(:restart_peer_connections, state) do
    destroy_peer_data()
    PeerNet.bootstrap_connections(state.node_uuid)
    connected_peers = __MODULE__.refresh_peer_data()
    Logger.warn(fn ->
      "restart_peer_connections // Connected to #{EsprezzoCore.PeerNet.count_peers} peers"
    end)
    {:ok, %{
      :authorized_peers => [],
      :connected_peers => connected_peers,
      :node_uuid => state.node_uuid
      }
    }
    schedule_restart_peer_connections()
    {:noreply, state}
  end
  @doc """
    iex> EsprezzoCore.PeerNet.PeerManager.notify_peers_with_status()
  """
  def notify_peers_with_status() do
    GenServer.call(__MODULE__, :notify_peers_with_status, :infinity)
  end
  def handle_call(:notify_peers_with_status, _from, state) do
    state.connected_peers
    |> Enum.each(fn p -> 
      Logger.warn "Notifying Peer #{p.remote_addr} // #{p.node_uuid} with new status"
      EsprezzoCore.PeerNet.Peer.send_status(p.pid)
    end)
    {:reply, state, state}
  end
  def handle_info(:notify_peers_with_status, state) do
    state.connected_peers
    |> Enum.each(fn p -> 
      Logger.warn "Notifying Peer #{p.remote_addr} // #{p.node_uuid} with new status"
      EsprezzoCore.PeerNet.Peer.send_status(p.pid)
    end)
    {:noreply, state}
  end

  def handle_call(:clear_peer_data, _from, state) do
    {:reply, state, state}
  end
  @doc """
  Collect all data from all peers to
  local state. Used on init.
  
  iex> EsprezzoCore.PeerNet.PeerManager.refresh_peer_data()

  """
  def refresh_peer_data do
    PeerSupervisor.list_peer_pids()
      |> Enum.map(fn pid -> 
        EsprezzoCore.PeerNet.Peer.peer_state(pid)
      end)
  end

  def destroy_peer_data do
    PeerSupervisor.list_peer_pids()
      |> Enum.map(fn pid -> 
        Logger.warn "Removing Peer: #{inspect(pid)}"
        EsprezzoCore.PeerNet.PeerSupervisor.remove_peer(pid)
      end)
  end


  defp schedule_restart_peer_connections() do
    Process.send_after(self(), :restart_peer_connections, 10000)
  end
 
  defp schedule_maintain_peer_connections() do
    Process.send_after(self(), :notify_peers_with_status, 10000)
  end

end
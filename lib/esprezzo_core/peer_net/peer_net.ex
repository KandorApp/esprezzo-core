defmodule EsprezzoCore.PeerNet do
  require IEx

  alias EsprezzoCore.PeerNet.PeerTracker
  alias EsprezzoCore.PeerNet.Client
  alias EsprezzoCore.PeerNet.Peer
  alias EsprezzoCore.PeerNet.WireProtocol.Commands
  """
  EsprezzoCore.PeerNet.peers
  """
  def peers do
    PeerTracker.list_peer_pids()
  end

  """
  EsprezzoCore.PeerNet.count_peers
  """
  def count_peers do
    PeerTracker.count_peers()
  end

  """
  EsprezzoCore.PeerNet.bootstrap_connections()
  """
  def bootstrap_connections(node_uuid) do
    Client.connect_to_bootstrap_nodes(node_uuid)
  end

  """
  {:ok, pid} = EsprezzoCore.PeerNet.connect("127.0.0.1", 30343)
  """
  def connect(ip, port) do
    Client.connect(ip, port)
  end
 
  """
  EsprezzoCore.PeerNet.ping_all()
  """
  def ping_all do
    __MODULE__.peers()
      |> Enum.each(fn pid -> 
        Commands.send("PING", pid)
      end)
  end

  def local_node_uuid() do
    EsprezzoCore.PeerNet.TCPServer.get_state()
    |> Map.get(:node_uuid)
  end
end
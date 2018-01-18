defmodule EsprezzoCore.PeerNet do

  alias EsprezzoCore.PeerNet.StateTracker
  alias EsprezzoCore.PeerNet.Client
  alias EsprezzoCore.PeerNet.Peer
  
  def peers do
    StateTracker.list_peers()
  end

  """
  EsprezzoCore.PeerNet.bootstrap_connections()
  """
  def bootstrap_connections do
    Client.connect_to_bootstrap_nodes()
  end

  """
  {:ok, pid} = EsprezzoCore.PeerNet.connect("127.0.0.1", 30343)
  """
  def connect(ip, port) do
    Client.connect(ip, port)
  end

  def peers do
    PeerTracker.list_peers()
  end

  """
  EsprezzoCore.PeerNet.send_message(pid, "Hello, Networking!")
  """
  def send_message(peer, message) do
    Peer.send_message(peer, message)
  end


end
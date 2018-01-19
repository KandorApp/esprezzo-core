defmodule EsprezzoCore.PeerNet.TCPHandler do
  require Logger
  alias EsprezzoCore.PeerNet.PeerTracker
  require IEx
  def start_link(ref, socket, transport, opts) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    {:ok, pid}
  end
         
  def init(ref, socket, transport, opts) do
    IEx.pry
    node_uuid = "xx"
    :ok = :ranch.accept_ack(ref)
    tcp_options = [:binary, {:packet, 4}, active: true, reuseaddr: true]
    :ok = transport.setopts(socket, tcp_options)
    {:ok, pid} = PeerTracker.add_peer(socket, transport, node_uuid)
    :ranch_tcp.controlling_process(socket, pid)
  end
  
end
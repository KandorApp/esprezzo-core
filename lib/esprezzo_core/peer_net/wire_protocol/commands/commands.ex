defmodule EsprezzoCore.PeerNet.WireProtocol.Commands do
  require IEx
  alias EsprezzoCore.PeerNet
  alias EsprezzoCore.PeerNet.Peer
  alias EsprezzoCore.WireProtocol.Commands.{Ping, Pong}
  
  @doc"""
  Use public API to emit genserver 
  callback msg for pid
  """
  def send("PING", pid) do
    Peer.send_message(pid, Ping.build)
  end
  
  @doc"""
  Use public API to emit genserver 
  callback msg for pid
  """
  def send("PONG", pid) do
    Peer.send_message(pid, Pong.build)
  end

  @doc"""
  Only return the command struct so
  we can send from calling process
  """
  def build("PONG") do
    Pong.build
  end

  def send("hello", pid, data) do
    Peer.send_message(pid, "HELLO")
  end

  def send("STATUS", pid, data) do
    Peer.send_message(pid, "HELLO")
  end

end
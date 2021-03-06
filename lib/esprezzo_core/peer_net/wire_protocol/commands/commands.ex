defmodule EsprezzoCore.PeerNet.WireProtocol.Commands do
  require IEx
  alias EsprezzoCore.PeerNet
  alias EsprezzoCore.PeerNet.Peer
  alias EsprezzoCore.WireProtocol.Commands.{Ping, Pong, Hello, Disconnect, Status, NewBlock, RequestBlocks}
  
  @doc"""
  Use public API to emit genserver 
  callback msg for pid
  """
  def send("PING", pid) do
    Peer.send_message(pid, Ping.build)
  end
  def build("PING") do
    Ping.build
  end

  @doc"""
  Use public API to emit genserver 
  callback msg for pid
  """
  def build("PONG") do
    Pong.build
  end

  def send("PONG", pid) do
    Peer.send_message(pid, Pong.build)
  end

  @doc"""
  Use public API to emit genserver 
  callback msg for pid
  """
  def build("HELLO") do
    Hello.build
  end

  def build("DISCONNECT") do
    Disconnect.build
  end
 
  def build("STATUS") do
    Status.build
  end

  def build("NEW_BLOCK", block) do
    NewBlock.build(block)
  end

  def build("REQUEST_BLOCKS", index) do
    RequestBlocks.build(index)
  end
end
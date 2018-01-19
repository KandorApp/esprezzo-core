defmodule EsprezzoCore.PeerNet.WireProtocol.Commands do
  require IEx
  alias EsprezzoCore.PeerNet
  alias EsprezzoCore.PeerNet.Peer
  alias EsprezzoCore.WireProtocol.Commands.Ping
  
  def send("PING", pid) do
    Peer.send_message(pid, Ping.build)
  end

  def send("PONG", pid, data) do
    Peer.send_message(pid, "PONG")
  end

  def send("hello", pid, data) do
    Peer.send_message(pid, "HELLO")
  end

  def send("STATUS", pid, data) do
    Peer.send_message(pid, "HELLO")
  end

end
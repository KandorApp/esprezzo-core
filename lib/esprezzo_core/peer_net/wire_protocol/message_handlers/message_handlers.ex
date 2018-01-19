defmodule EsprezzoCore.PeerNet.WireProtocol.MessageHandlers do
  @moduledoc"""
  Parser/Router for incoming commands
  This only returns commnds to the calling
  Peer process and it returns the messages
  directly.
  """
  require Logger
  require IEx
  alias EsprezzoCore.PeerNet
  alias EsprezzoCore.PeerNet.WireProtocol.Commands


  def process(message, socket, transport) do

    command_struct = Poison.decode!(message)

    case command_struct["command"] do
      "PING" ->
        Logger.warn(fn ->
          "Received PING from #{inspect(socket)} // Sending PONG}."
        end)
        Commands.build("PONG")
      "PONG" ->
        Logger.warn(fn ->
          "Received PONG // from #{inspect(socket)}}."
        end)
      message ->
        Logger.warn(fn ->
          "Received unknown message #{inspect(message)} from #{inspect(socket)}."
        end)
    end

  end

end
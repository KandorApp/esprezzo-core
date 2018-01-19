defmodule EsprezzoCore.PeerNet.WireProtocol.MessageHandlers do
  @moduledoc"""
  Parser/Router for incoming commands
  is this a parser or a handler.. identity crisis?
  """

  require Logger
  alias EsprezzoCore.PeerNet
  require IEx

  def direct(message) do

    command = Poison.decode!(message)

    IEx.pry
    case message do
      "PING" ->
        Logger.warn(fn ->
          #"Received PING from #{inspect(socket)} // Sending PONG}."
        end)
        #transport.send(socket, "PONG")
      "PONG" ->
        Logger.warn(fn ->
          #"Received PONG // from #{inspect(socket)}}."
        end)
      message ->
        Logger.warn(fn ->
          #"Received message #{inspect(message)} from #{inspect(socket)}."
        end)
    end

  end

end
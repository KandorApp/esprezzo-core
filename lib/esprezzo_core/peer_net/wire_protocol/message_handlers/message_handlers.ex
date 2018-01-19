defmodule EsprezzoCore.PeerNet.WireProtocol.MessageHandlers do
  @moduledoc"""
  Parser/Dispatcher for incoming commands.
  Returns command structs to the calling
  Peer process.
  """
  require Logger
  require IEx
  alias EsprezzoCore.PeerNet
  alias EsprezzoCore.PeerNet.WireProtocol
  alias EsprezzoCore.PeerNet.WireProtocol.Commands

  def process(message, socket, transport, remote_addr) do

    command_struct = Poison.decode!(message)

    case command_struct["command"] do
      "PING" ->
        Logger.warn(fn ->
          "Received PING from #{inspect(socket)} // Sending PONG to #{remote_addr}"
        end)
        {:ok, Commands.build("PONG")}
      "PONG" ->
        Logger.warn(fn ->
          "Received PONG // from #{inspect(socket)} // #{remote_addr}"
        end)
        :ok
      "HELLO" ->
        Logger.warn(fn ->
          "Received HELLO from #{inspect(socket)} // Checking Version compatibility with #{remote_addr}"
        end)
        case WireProtocol.is_version_compatible?() do
          true ->
            {:ok, Commands.build("STATUS")}
          false ->
            {:error, Commands.build("DISCONNECT")}
        end
      message ->
        Logger.warn(fn ->
          "Received unknown message #{inspect(message)} from #{inspect(socket)}."
        end)
    end

  end

end
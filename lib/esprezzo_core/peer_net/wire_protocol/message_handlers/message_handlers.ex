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
  alias EsprezzoCore.PeerNet.WireProtocol.StatusHandler
  alias EsprezzoCore.PeerNet.WireProtocol.RequestBlocksHandler

  def process(message, socket, transport, remote_addr) do

    command_struct = Poison.decode!(message, keys: :atoms)

    case command_struct.command do
      "STATUS" ->
        Logger.warn(fn ->
          "Received STATUS from #{inspect(message)}"
        end)
       
        case PeerNet.local_node_uuid() == command_struct.node_uuid do
          true ->
            Logger.warn("INVALID ORIGIN NODE // SELF")
            :noreply
          false ->
            StatusHandler.process(command_struct)
        end
      "PING" ->
        Logger.warn(fn ->
          "Received PING from #{inspect(socket)} // Sending PONG to #{remote_addr}"
        end)
        {:ok, Commands.build("PONG")}

      "PONG" ->
        Logger.warn(fn ->
          "Received PONG // from #{inspect(socket)} // #{remote_addr}"
        end)
        :noreply

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

        
      # Handles New block either coming in from a peer or generated locally
      "NEW_BLOCK" ->
        Logger.warn(fn ->
          "Received NEW_BLOCK // from #{inspect(socket)} // #{remote_addr}"
          "ARE WE VALIDATING THIS?"
        end)
        block = command_struct.blockData
        # Add block to chain
        EsprezzoCore.Blockchain.CoreMeta.push_block(block)
        {:ok, Commands.build("STATUS")}
    
      #  Handle Request for blocks at starting index  
      #  Should return block by index by returning command directly to calling peer process  
      "REQUEST_BLOCKS" ->
        Logger.warn(fn ->
          "Received BLOCK_REQUEST for HEIGHT: #{command_struct.index} // from #{inspect(socket)} // #{remote_addr}"
          "ARE WE VALIDATING THIS?"
        end)
        RequestBlocksHandler.process(command_struct)

      # Fallback unknown_message
      message ->
        Logger.warn(fn ->
          "Received unknown_message #{inspect(message)} from #{inspect(socket)}."
        end)
    end

  end

end
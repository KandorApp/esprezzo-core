defmodule EsprezzoCore.PeerNet.WireProtocol.MessageHandlers do
  @moduledoc"""
  Parser/Dispatcher for incoming commands.
  Returns command structs to the calling
  Peer process.
  """
  require Logger
  require IEx

  alias EsprezzoCore.Blockchain
  alias EsprezzoCore.PeerNet
  alias EsprezzoCore.PeerNet.WireProtocol
  alias EsprezzoCore.PeerNet.WireProtocol.Commands
  alias EsprezzoCore.PeerNet.WireProtocol.StatusHandler
  alias EsprezzoCore.PeerNet.WireProtocol.RequestBlocksHandler
  alias EsprezzoCore.BlockChain.Settlement.BlockValidator 
  alias EsprezzoCore.Blockchain.CoreMeta

  def process(message, socket, transport, remote_addr) do

    command_struct = Poison.decode!(message, keys: :atoms)

    case command_struct.command do
      "STATUS" ->
       
        case PeerNet.local_node_uuid() == command_struct.node_uuid do
          true ->
            # Logger.warn("INVALID ORIGIN NODE // SELF")
            :noreply
          false ->
            Logger.warn(fn ->
              "Received STATUS from  #{remote_addr} // HEIGHT (Remote/Local) #{command_struct.block_height}/#{Blockchain.current_height()} // #{inspect(message)}"
            end)    
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
        end)
        block = command_struct.blockData
        block_idx = CoreMeta.get_block_index()
        case BlockValidator.is_valid?(block, block_idx) do
          true -> 
            IEx.pry
            Logger.warn "Adding New VALID Block // Pushing to Chain"
            EsprezzoCore.Blockchain.CoreMeta.push_block(block)
            Logger.warn "New VALID Block Added // Requesting next block"
            {:ok, Commands.build("REQUEST_BLOCKS", Blockchain.current_height() + 1)}
          false ->
            Logger.warn "New Block FAILED VALIDATION // Requesting next block"
            :timer.sleep(666)
            :noreply
            {:ok, Commands.build("REQUEST_BLOCKS", Blockchain.current_height() + 1)}
            
        end
     
      #  Handle Request for blocks at starting index  
      #  Should return block by index by returning command directly to calling peer process  
      "REQUEST_BLOCKS" ->
        Logger.warn(fn ->
          "Received REQUEST_BLOCKS for HEIGHT: #{command_struct.index} // from #{remote_addr}"
        end)
        RequestBlocksHandler.process(command_struct)

      # Fallback unknown_message
      message ->
        Logger.warn(fn ->
          "Received unknown_message #{inspect(message)} from #{inspect(socket)}."
        end)
    end

  end

  def is_struct?(map) do
    Map.has_key?(map, :__struct__)
  end

end
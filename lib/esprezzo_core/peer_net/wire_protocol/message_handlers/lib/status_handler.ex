defmodule EsprezzoCore.PeerNet.WireProtocol.StatusHandler do
  require Logger
  require IEx
  alias EsprezzoCore.Blockchain
  alias EsprezzoCore.PeerNet.WireProtocol.Commands



  @doc """
  Is the genesis hash valid?
  Does the sender have a higher block count that I do?
  """
  def process(command) do
    case command.block_height > Blockchain.current_height() do
      true -> 
        # ask for blocks
        Logger.warn("STATUS RECIEVED // REQUESTING NEW BLOCK #{Blockchain.current_height()}")
        {:ok, Commands.build("REQUEST_BLOCKS", Blockchain.current_height())}
      false ->
        Logger.warn("SYNC_COMPLETE")
        :noreply
    end
    
  end

end
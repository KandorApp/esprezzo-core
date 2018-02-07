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
    inspect(command)
    Logger.warn("STATUS RECEIVED FROM: ")
    Logger.warn("STATUS RECEIVED // LOCAL HEIGHT: #{Blockchain.current_height()}")
    Logger.warn("STATUS RECEIVED // REMOTE HEIGHT: #{command.block_height}")
    case command.block_height >= Blockchain.current_height() do
      true -> 
        # ask for blocks
        Logger.warn("REQUESTING NEW BLOCK #{Blockchain.current_height()}")
        {:ok, Commands.build("REQUEST_BLOCKS", Blockchain.current_height())}
      false ->
        Logger.warn("SYNC_COMPLETE")
        :noreply
    end
  end

end
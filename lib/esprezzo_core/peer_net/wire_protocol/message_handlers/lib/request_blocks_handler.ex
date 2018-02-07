defmodule EsprezzoCore.PeerNet.WireProtocol.RequestBlocksHandler do
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
    Logger.warn("REQUEST_BLOCKS RECEIVED FROM: ")
    Logger.warn("REQUEST_BLOCKS RECEIVED // LOCAL HEIGHT: #{Blockchain.current_height()}")
    Logger.warn("REQUEST_BLOCKS RECEIVED // REMOTE HEIGHT: #{command.block_height}")
    IEx.pry
    # case command.block_height >= Blockchain.current_height() do
    #   true -> 
    #     
    #     # ask for blocks
    #     {:ok, Commands.build("REQUEST_BLOCKS", Blockchain.current_height())}
    #   false ->
    #     {:noreply, "sync_complete"}
    # end
  end

end
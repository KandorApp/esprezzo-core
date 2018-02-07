defmodule EsprezzoCore.PeerNet.WireProtocol.RequestBlocksHandler do
  require Logger
  require IEx
  alias EsprezzoCore.Blockchain
  alias EsprezzoCore.PeerNet.WireProtocol.Commands
  alias EsprezzoCore.Blockchain.CoreMeta


  @doc """
  Is the genesis hash valid?
  Does the sender have a higher block count that I do?
  """
  def process(command) do
    inspect(command)
    Logger.warn("REQUEST_BLOCKS_AT_HEIGHT: #{command.index()}")
    case CoreMeta.get_block_at_height(command.index) do
      nil -> :noreply
      block ->
        {:ok, Commands.build("NEW_BLOCK", block)}
    end
  end

end
defmodule EsprezzoCore.PeerNet.WireProtocol.NewBlockHandler do
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
    Logger.warn("NEW_BLOCK RECEIVED")
    block = command.blockData
    EsprezzoCore.Blockchain.CoreMeta.push_block(block)
    :noreply
  end

end
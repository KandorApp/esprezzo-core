defmodule EsprezzoCore.PeerNet.WireProtocol.StatusHandler do
  require Logger
  require IEx
  alias EsprezzoCore.Blockchain



  @doc """
  Is the genesis hash valid?

  Does the sender have a higher block count that I do?


  """
  def process(command) do
    inspect(command)
    case command.block_height >= Blockchain.current_height() do
      true -> 
        # ask for blocks
        IEx.pry
      false ->
        false
    end
  end

end
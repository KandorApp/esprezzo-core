defmodule EsprezzoCore.Blockchain.Settlement.CoreChain do
  require IEx
  alias EsprezzoCore.BlockChain.Settlement.Structs.{Block, BlockHeader, Transaction}
  alias EsprezzoCore.BlockChain.Settlement.BlockValidator
  alias EsprezzoCore.Blockchain.Persistence
  alias EsprezzoCore.Blockchain.CoreMeta
  alias EsprezzoCore.Blockchain.Forger
  alias EsprezzoCore.Crypto.Hash

  @doc """
    EsprezzoCore.Blockchain.Settlement.CoreChain.reinitialize()
  """
  # def reinitialize() do
  #   Persistence.clear_blocks()
  #   genesis_block = Forger.forge_genesis_block()
  #   case Persistence.persist_block(genesis_block) do
  #     {:ok, _} -> {:ok}
  #     {:error, _} -> {:error}
  #   end
  # end


  # @spec best_block() :: Block
  # def best_block() do
  #   #Persistence.best_block()
  #   CoreMeta.best_block
  # end

  # @spec current_height() :: Integer.t
  # def current_height() do
  #   Persistence.current_height()
  # end

  @spec validate_block(Block) :: Boolean
  def validate_block(block) do
    BlockValidator.validate(block)
  end

end
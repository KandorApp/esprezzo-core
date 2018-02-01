defmodule EsprezzoCore.Blockchain do
  require IEx
  alias EsprezzoCore.Blockchain.Persistence.Schemas.{Block}
  alias EsprezzoCore.BlockChain.Settlement.Structs.BlockHeader
  alias EsprezzoCore.Blockchain.Settlement.CoreChain
  alias EsprezzoCore.Crypto.Hash
  alias EsprezzoCore.Crypto.Base58
  alias EsprezzoCore.Blockchain.CoreMeta
  alias EsprezzoCore.BlockChain.Settlement.BlockValidator
  @doc """
    Clear Chain and reinitialize database with genesis block
    EsprezzoCore.Blockchain.reinitialize_core
  """
  @spec reinitialize_core() :: {:ok} | {:error}
  def reinitialize_core() do
    CoreChain.reinitialize()
  end

  @doc """
    EsprezzoCore.Blockchain.best_block()
  """
  def best_block() do 
    CoreMeta.best_block()
  end

  def block_is_valid?(block) do
    BlockValidator.is_valid?(block)
  end

  @doc """
  EsprezzoCore.Blockchain.current_height()
  """
  def current_height() do 
    CoreMeta.height()
  end

  def latest_block_overview() do
    CoreMeta.latest_block_overview()
  end

  def block_exists?(hash) do
    
  end
  
end
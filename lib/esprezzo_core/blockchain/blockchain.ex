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
    Get (n) number of blocks starting at (start), w/limit (limit)
    EsprezzoCore.Blockchain.get_blocks(0, 10)
  """
  @spec get_blocks(Integer.t(), Integer.t()) :: List.t()
  def get_blocks(start, count) do
    CoreMeta.get_n_blocks(start, count)
  end

  @doc """
    Returns top block in chain
    iex> EsprezzoCore.Blockchain.best_block() 
  """
  @spec best_block() :: Map.t()
  def best_block() do 
    CoreMeta.best_block()
  end

  @doc """
    RChecks if block is valid
    iex> EsprezzoCore.Blockchain.block_is_valid?() 
  """
  @spec block_is_valid?(Block.t()) :: Boolean.t()
  def block_is_valid?(block) do
    BlockValidator.is_valid?(block)
  end

  @doc """
    Returns Blockchain height
    iex> EsprezzoCore.Blockchain.current_height()
  """
  @spec current_height() :: Integer.t()
  def current_height() do 
    CoreMeta.height()
  end

  @doc """
    Take a look at this.. for stats?
  """
  @spec latest_block_overview() :: Map.t()
  def latest_block_overview() do
    CoreMeta.latest_block_overview()
  end

  @doc """
    Check if a block exists for a hash
    iex> EsprezzoCore.Blockchain.block_exists?("xoxoxox")
  """
  @spec block_exists?(String.t()) :: Boolean.t()
  def block_exists?(hash) do
    case CoreMeta.get_block(hash) do
      nil -> false
      _ -> true
    end
  end

  @doc """
    Get a block by its hash
    iex> EsprezzoCore.Blockchain.get_block("xoxoxox")
  """
  @spec get_block(String.t()) :: Map.t()
  def get_block(hash) do
    CoreMeta.get_block(hash)
  end

end
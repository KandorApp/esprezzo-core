defmodule EsprezzoCore.BlockChain.Settlement.BlockValidator do
  require IEx
  require Logger

  alias EsprezzoCore.Crypto.Hash
  alias EsprezzoCore.Blockchain.CoreMeta
  alias EsprezzoCore.BlockChain.Settlment.Structs.Block
  alias EsprezzoCore.BlockChain.Settlement.Structs.BlockHeader

  @spec validate_blocks(List.t()) :: Boolean.t
  def validate_blocks(blocks) do
    
    case Enum.count(blocks) > 0 do
      true ->
        [block | blocks] = blocks
        case is_valid?(block) do
          true -> 
            #IEx.pry
            Logger.warn "Block is valid"
            validate_blocks(blocks)
          false -> 
            Logger.warn "Invalid Block found"
            false
        end
      false -> true
    end

  end 
  @doc """
  Validate a Settlement Ledger block 
  Current Conditions
  EsprezzoCore.BlockChain.Settlement.BlockValidator.validate(block)
  true <- parent_exists?(block.header.previous_hash),
  """
  @spec is_valid?(Block) :: Boolean
  def is_valid?(block) do
    with delta_hash <- hash_header(block.header),
      true <- difficulty_is_valid?(block.header, delta_hash),
      true <- hash_is_valid?(block, delta_hash),
      do: true
  end

  @doc """
    Parses and compares the onteger value of the hexadecimal 
    hash with the difficulty limit claimed my block
  """
  defp difficulty_is_valid?(header, delta_hash) do
    {value, _} = Integer.parse(delta_hash, 16)  
    case value <= header.difficulty_target do
      true ->
        Logger.warn "Block Difficulty is valid"
        true
      false -> 
        Logger.error "Block Difficulty not valid"
        false
    end
  end

  @doc """
    Rehashes block to make sure the embedded txid is correct 
  """
  @spec hash_is_valid?(Block.t(), String.t()) :: Boolean.t()
  defp hash_is_valid?(block, delta_hash) do
    Logger.warn "block.block_header: #{block.header_hash}"
    Logger.warn "new_hash: #{delta_hash}"
    case delta_hash == block.header_hash do
      true ->
        Logger.warn "Block hash is valid"
        true
      false -> 
        Logger.error "Block hash is not valid"
        false
    end
  end

  @spec parent_exists?(String.t()) :: Boolean.t()
  def parent_exists?(hash) do
    case CoreMeta.block_exists?(hash) do
      false -> 
        Logger.warn "Parent Block Does Not Exists"
        false
      true ->
        Logger.warn "Parent Block Exists"
        true
    end
  end

  @doc """
    Create the hash of the header w/nonce
    TODO: DRY this up
  """
  def hash_header(%BlockHeader{version: v, previous_hash: h, timestamp: ts, txns_merkle_root: mr, nonce: nonce}) do  
    "#{v}#{h}#{ts}#{mr}#{nonce}"
      |> Hash.sha256()
      |> String.downcase()
  end

  def empty?([]), do: true
  def empty?(list) when is_list(list) do
    false
  end

end
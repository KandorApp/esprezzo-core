defmodule EsprezzoCore.BlockChain.Settlement.BlockValidator do
  require IEx
  require Logger
  alias EsprezzoCore.BlockChain.Settlment.Structs.Block
  alias EsprezzoCore.BlockChain.Settlement.Structs.BlockHeader
  alias EsprezzoCore.Crypto.Hash

  @doc """
  Validate a Settlement Ledger block 
  Current Conditions
  EsprezzoCore.BlockChain.Settlement.BlockValidator.validate(block)
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
  def difficulty_is_valid?(header, delta_hash) do
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
  @spec hash_is_valid?(Block.t, String.t) :: Boolean.t
  def hash_is_valid?(block, delta_hash) do
    case delta_hash == hash_header(block.header) do
      true ->
        Logger.warn "Block hash is valid"
        true
      false -> 
        Logger.error "Block hash is not valid"
        false
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

end
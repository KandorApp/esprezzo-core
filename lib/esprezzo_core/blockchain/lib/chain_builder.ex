defmodule EsprezzoCore.Blockchain.ChainBuilder do
  require IEx
  alias EsprezzoCore.Blockchain.Persistence
  alias EsprezzoCore.BlockChain.Settlement.Structs.{Block, BlockHeader}
  
  @spec build_blockchain(List.t, Map.t, Map.t) :: List.t
  def build_blockchain(blocks, transactions, block_txn_index) do
    Enum.reduce(blocks, %{}, fn (x, acc) -> 
      # IEx.pry
      txns = Map.take(transactions, Map.get(block_txn_index, x.header_hash))
      x = x
      |> Map.put(:txns, Map.values(txns))
      |> Map.put(:header, struct(BlockHeader, Persistence.sanitize(x.header)))
      Map.put(acc, x.header_hash, struct(Block, Persistence.sanitize(x)))
    end)
  end

  @spec build_transaction_map(List.t()) :: Map.t() 
  def build_transaction_map(txns) do
    Enum.reduce(txns, %{}, fn (x, acc) -> 
      Map.put(acc, x.txid, Persistence.sanitize(x))
    end)
  end

  @doc """
  May be wrong
  Map of BLOCKHASH => [txid,txid,txid]
  """
  def build_transactions_by_block_index(transactions) do
    transactions
    |> Enum.reduce(%{}, fn (x, acc) -> 
      case Map.has_key?(acc, x.txid) do
        true ->
          Map.put(acc, x.block_hash,  acc ++ [x.txid])
        false ->
          Map.put(acc, x.block_hash, [x.txid])
      end
    end)
  end

  def build_block_index(blocks) do
    Enum.map(blocks, fn x -> x.header_hash end)
  end

  def build_txn_index(transactions) do
    Enum.map(transactions, fn x -> x.txid end)
  end


end
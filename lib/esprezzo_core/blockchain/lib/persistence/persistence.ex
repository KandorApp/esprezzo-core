defmodule EsprezzoCore.Blockchain.Persistence do
  require IEx
  require Logger
  alias EsprezzoCore.Blockchain.Persistence.Schemas.{Block, Transaction}
  alias EsprezzoCore.Repo

  @doc """
    EsprezzoCore.Blockchain.Persistence.clear_blocks
    EsprezzoCore.Blockchain.Settlement.CoreChain.reinitialize()
  """
  def clear_blocks do
    Block
    |> Repo.delete_all
  end

  @doc """

  """
  def persist_block(block) do
    Logger.warn "Persisting block: #{block.header_hash}"
    txns = block.txns
    txn_data = Enum.map(txns, fn t ->
      txn = Map.from_struct(t) 
      txn = Map.put(txn, :block_hash, block.header_hash)
      case persist_txn(txn) do
        {:ok, txn} -> txn
        {:error, changeset} ->
          Logger.error "Could not persist txn: #{txn.txid}"
      end
    end)
    block_data = Map.from_struct(Map.delete(block, :txns))
    block_data = Map.put(block_data, :header, Map.from_struct(block_data.header))
    case _persist_block(block_data) do
      {:ok, block} -> 
        block
      {:error, _} ->
        IEx.pry
        :error
    end
  end

  def _persist_block(block_map) do
    IEx.pry
    cs = Block.changeset(%Block{}, block_map)
    Repo.insert(cs)
  end

  def persist_txn(txn_map) do
    Transaction.changeset(%Transaction{}, txn_map)
    |> Repo.insert()
  end

  def best_block() do
    Block.last
  end
end

defmodule EsprezzoCore.Blockchain.Persistence do
  require IEx

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

  def persist_block(block) do
    txns = block.txns
    txn_data = Enum.map(txns, fn t ->
      txn = Map.from_struct(t) 
      persist_txn(txn)
    end)
  
    block_data = Map.from_struct(Map.delete(block, :txns))
    _persist_block(block_data)
  end

  def _persist_block(block_map) do
    cs = Block.changeset(%Block{}, block_map)
    Repo.insert(cs)
  end

  def persist_txn(txn_map) do
    IEx.pry
    cs = Transaction.changeset(%Transaction{}, txn_map)
    Repo.insert(cs)
    txn_map
  end

  def best_block() do
    Block.last
  end
end

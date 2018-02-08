defmodule EsprezzoCore.Blockchain.Persistence do
  require IEx
  require Logger
  alias EsprezzoCore.Blockchain.Persistence.Schemas.{Block, Transaction}
  alias EsprezzoCore.BlockChain.Settlement.Structs
  alias EsprezzoCore.Repo

  @doc """
    EsprezzoCore.Blockchain.Persistence.clear_blocks
    EsprezzoCore.Blockchain.Settlement.CoreChain.reinitialize()
  """
  def clear_all do
    clear_blocks()
    clear_transactions()
  end

  def clear_blocks do
    Block
    |> Repo.delete_all
  end

  def clear_transactions do
    Transaction
    |> Repo.delete_all
  end

  @doc """
    TODO: wrap in sql transaction
  """
  def persist_block(block) do
    Logger.warn "Persisting block: #{block.header_hash}"
    txns = block.txns
    txn_data = Enum.map(txns, fn t ->
      #IEx.pry
      #txn = Map.from_struct(t)
      txn = Map.put(t, :block_hash, block.header_hash)
      case persist_txn(txn) do
        {:ok, txn} -> 
          sanitize(txn)
        {:error, changeset} ->
          Logger.error "Could not persist txn: #{txn.txid}"
      end
    end)
    block_data = Map.delete(block, :txns)
    block_data = Map.put(block_data, :header, block_data.header)
    case _persist_block(block_data) do
      {:ok, block} ->
        block = Map.put(block, :txns, txn_data)
        {:ok, block}
      {:error, changeset} ->
        Logger.error "Persisting Block Failed"
        {:error, changeset}
    end
  end


  @doc """
    EsprezzoCore.Blockchain.Persistence.load_block(hash)
  """
  def load_block(hash) do
      case Block.find(hash) do
        nil -> nil
        block -> 
          transactions = Enum.map(Transaction.for_block(block.header_hash), fn t -> 
            t
            |> Map.put(:vin, Enum.map(t.vin, fn x -> sanitize(x) end))
            |> Map.put(:vout, Enum.map(t.vout, fn x -> sanitize(x) end))
            |> sanitize()
          end)
          Map.put(block, :txns, transactions)
            |> Map.put(:header, sanitize(block.header))
            |> sanitize()
      end
  end

  def _persist_block(block_map) do
    case Block.find(block_map.header_hash) do
      nil -> 
        Logger.warn "block not found.. storing"
        block_map = sanitize(block_map)
        header = case is_struct?(block_map.header) do
          true -> 
            Map.from_struct(block_map.header)
          false ->
            block_map.header
        end
        block_map = Map.put(block_map, :header, header)

        cs = Block.changeset(%Block{}, block_map)
        Repo.insert(cs)
      block ->
        Logger.warn "block header already exists in storage"
        {:ok, block}
    end
   
  end

  def persist_txn(txn_map) do
    case Transaction.find(txn_map.txid) do
      nil -> 
        Logger.warn "TXN not found.. storing"
        txn_map = case is_struct?(txn_map) do
          true -> 
            Map.from_struct(txn_map)
          false ->
            txn_map
        end
        Transaction.changeset(%Transaction{}, txn_map)
        |> Repo.insert()
      txn -> 
        Logger.warn "TXN already exists in storage"
        {:ok, txn}
    end

  end

  def is_struct?(map) do
    Map.has_key?(map, :__struct__)
  end

  def best_block() do
    Block.last
  end

  def genblock() do
    b = Block.first
    load_block(b.header_hash)
  end

  def load_chain() do
    Block.all()
    |> Enum.map(fn x -> Map.put(x, :header, sanitize(x.header)) end)
  end

  def load_transactions() do
    Transaction.all()
  end

  def current_height() do
    Block.count()
  end

  def sanitize(map) do
    Map.drop(map, [:__meta__, :__struct__])
  end

end

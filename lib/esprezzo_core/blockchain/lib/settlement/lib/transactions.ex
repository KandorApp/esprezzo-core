defmodule EsprezzoCore.Blockchain.Settlment.Transactions do
  
  require IEx
  alias EsprezzoCore.BlockChain.Settlement.Structs.{Transaction}
  alias EsprezzoCore.Crypto.Hash

  @doc """
    Update txn with hashes
  """
  @spec write_transaction_hash(Transaction.t) :: Transaction.t
  def write_transaction_hash(transaction) do
    Map.put(transaction, :txid, hash_transaction(transaction))
  end

  def hash_transaction(%Transaction{version: v, timestamp: ts, vin: vin_list, vout: vout_list}) do
    "#{v}#{ts}#{hash_vin_list(vin_list)}#{hash_vout_list(vout_list)}"
    |> Hash.sha256()
    |> Hash.sha256()
    |> String.downcase()
  end

  @doc """
    Reduce the entire list of txns to a root hash
  """
  def write_merkle_root_to_block_header(block) do
    root = Enum.reduce(block.txns, "", fn (x, acc) -> 
      acc <> x.txid
    end)
    |> Hash.sha256()
    |> Hash.sha256()
    |> String.downcase()

    Map.put(block, :header, Map.put(block.header, :txns_merkle_root, root))
  end
 
  @doc """
    Reduce the entire list of inputs to a single hash
  """
  @spec hash_vin_list(List.t) :: String.t
  def hash_vin_list(vin_list) do
    Enum.reduce(vin_list, nil, fn (x, acc) -> 
      case acc do
        nil -> 
          hash_input(x)
        h -> 
          h <> hash_input(x)
      end
    end)
    |> Hash.sha256()
    |> Hash.sha256()
    |> String.downcase()
  end

  @doc """
    Reduce the entire list of outputs to a single hash
  """
  @spec hash_vout_list(List.t) :: String.t
  def hash_vout_list(vout_list) do
    Enum.reduce(vout_list, nil, fn (x, acc) -> 
      case acc do
        nil -> 
          hash_output(x)
        h -> 
          h <> hash_output(x)
      end
    end)
    |> Hash.sha256()
    |> Hash.sha256()
    |> String.downcase()
  end

  @doc """
    Hash a single input
  """
  @spec hash_input(Map.t) :: String.t
  def hash_input(%{script_sig: sig, txid: txid, vout: vo }) do  
    "#{sig}#{txid}#{vo}"
    |> Hash.sha256()
    |> Hash.sha256()
    |> String.downcase()
  end

  @doc """
    Hash a single input
  """
  @spec hash_output(Map.t) :: String.t
  def hash_output(%{val: val, locking_contract: contract }) do  
    "#{val}#{contract}"
    |> Hash.sha256()
    |> Hash.sha256()
    |> String.downcase()
  end

end
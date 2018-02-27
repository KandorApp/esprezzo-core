defmodule EsprezzoCore.Blockchain.Settlement.CoreChain.Genesis do
  require IEx
  require Logger
  alias EsprezzoCore.BlockChain.Settlement.Structs.{Block, BlockHeader, Transaction}
  alias EsprezzoCore.BlockChain.Settlement.BlockValidator
  alias EsprezzoCore.Blockchain.Settlment.Transactions
  alias EsprezzoCore.Blockchain.Persistence
  alias EsprezzoCore.Blockchain.Forger
  alias EsprezzoCore.Blockchain.CoreMeta
  
  @doc """
    EsprezzoCore.Blockchain.Settlement.CoreChain.Genesis.regenerate()
  """
  @spec regenerate() :: :ok | :error
  def regenerate() do
    Persistence.clear_all()
    genesis_block = Forger.Hashery.forge_genesis_block(genesis_block_template())
    case Persistence.persist_block(genesis_block) do
      {:ok, block} -> 
        Logger.warn "Pushing Genesis Block To MemChain"
        EsprezzoCore.Blockchain.CoreMeta.push_block(block)
        {:ok, block}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
    EsprezzoCore.Blockchain.Settlement.CoreChain.Genesis.genesis_hash()
  """
  def genesis_hash do
    genesis_block_template()
    |> Map.get(:header_hash)
  end


  @doc """
    EsprezzoCore.Blockchain.Settlement.CoreChain.Genesis.reinitialize()
  """
  @spec reinitialize() :: {:ok, any} | {:error, any}
  def reinitialize() do
    Persistence.clear_all()
    genesis_block = genesis_block_template()
    |> sanitize()

    case BlockValidator.is_valid?(genesis_block) do
      true ->
        case Persistence.persist_block(genesis_block) do
          {:ok, block} -> 
            Logger.warn "Genesis Block Saved"
            # EsprezzoCore.Blockchain.CoreMeta.push_block(sanitize(block))
            {:ok, block}
          {:error, changeset} ->
            Logger.error "Failed To Persist Genesis Block"
            {:error, changeset} 
        end
      false ->
        Logger.error "Invalid block"
        {:error, "Invalid block"} 
    end
  end

  @doc """
    Genesis Block before hashing
  """
  @spec genesis_block_template() :: Block.t
  def genesis_block_template do
    gen_timestamp = :os.system_time(:seconds)
    %Block{
      header_hash: "00001b685354953b0ccadb721f858834fdd208888fdf358598da0e8aa8a70b20",
      timestamp: 1517188208,
      block_number: 0,
      header: %BlockHeader{
        version: 0,
        previous_hash: "0x",
        txns_merkle_root: "51e2a4b370223d0a2bb29e051dcc5c2ab41132e588b72eec3f8d9faad6f895ab",
        timestamp: 1517188208,
        difficulty_target: 1000000000000000000000000000000000000000000000000000000000000000000000000,
        nonce: 236368
      }
    } 
    |> Map.put(:txns, genesis_txns())
    |> Transactions.write_merkle_root_to_block_header()
  end

  @doc """
    t = EsprezzoCore.Blockchain.Settlement.CoreChain.genesis_txns |> List.first
  """
  @spec genesis_txns :: Transaction.t
  def genesis_txns do
  [
    %Transaction{ 
      version: 0,
      timestamp: 1517188208,
      txid: "1100a0e32da7fa1869b8fba00823b2c354351872e73607fbd3510781c8d64ce8",
      vin: [
        %{
          txid: "0x00",
          vout: "0x00",
          script_sig: "0x"
        },
      ],
      vout: [
        %{
          val: "100000000",
          locking_contract: "OP_DUP OP_HASH160 1Fv1regg69W4AXhfbnFKR418qT8SXhhxRG OP_EQUALVERIFY OP_CHECKSIG" 
        }
      ]
    }
  ] 
  |> 
    Enum.map(fn t -> 
      Transactions.write_transaction_hash(t)
    end)
  
  end

  @doc """

  """
  def persist_genesis_block(block) do
    case BlockValidator.is_valid?(block) do
      true ->
        case Persistence.persist_block(block) do
          {:ok, block} -> 
            Logger.warn "Persisting Genesis Block"
            {:ok, block}
          {:error, changeset} ->
            Logger.error "Failed To Persist Genesis Block"
            {:error, changeset} 
        end
      false ->
        Logger.error "Invalid block"
        {:error, "Invalid block"} 
    end
  end


  defp sanitize(map) do
    Map.drop(map, [:__meta__, :__struct__])
  end
end
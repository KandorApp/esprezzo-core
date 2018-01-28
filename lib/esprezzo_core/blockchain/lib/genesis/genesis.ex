defmodule EsprezzoCore.Blockchain.Settlement.CoreChain.Genesis do
  require IEx
  alias EsprezzoCore.BlockChain.Settlement.Structs.{Block, BlockHeader, Transaction}
  alias EsprezzoCore.Blockchain.Settlment.Transactions
  alias EsprezzoCore.BlockChain.Settlement.BlockValidator
  alias EsprezzoCore.Blockchain.Persistence
  alias EsprezzoCore.Blockchain.Forger

  @doc """
    EsprezzoCore.Blockchain.Settlement.CoreChain.Genesis.regenerate()
  """
  @spec regenerate() :: :ok | :error
  def regenerate() do
    Persistence.clear_blocks()
    genesis_block = Forger.forge_genesis_block(genesis_block_template)
    case Persistence.persist_block(genesis_block) do
      {:ok, _} -> :ok
      {:error, _} -> :error
    end
  end

  @doc """
    Genesis Block before hashing
  """
  @spec genesis_block_template() :: Block.t
  def genesis_block_template do
    gen_timestamp = :os.system_time(:seconds)
    b = %Block{
      header_hash: "0x",
      timestamp: gen_timestamp,
      header: %BlockHeader{
        version: 0,
        previous_hash: "0x",
        txns_merkle_root: "0x",
        timestamp: gen_timestamp,
        difficulty_target: 1000000000000000000000000000000000000000000000000000000000000000000000000,
        nonce: 138139
      }
    } 
    |> Map.put(:txns, genesis_txns())
    |> Transactions.write_merkle_root_to_block_header()

    IEx.pry
    b
  end

  @doc """
  t = EsprezzoCore.Blockchain.Settlement.CoreChain.genesis_txns |> List.first
  """
  @spec genesis_txns :: Transaction.t
  def genesis_txns do
  [
    %Transaction{ 
      version: 0,
      timestamp: :os.system_time(:seconds),
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

end
defmodule EsprezzoCore.Blockchain.Settlement.CoreChain do
  require IEx
  alias EsprezzoCore.BlockChain.Settlement.Structs.{Block, BlockHeader, Transaction}
  alias EsprezzoCore.BlockChain.Settlement.BlockValidator
  alias EsprezzoCore.Blockchain.Persistence

  @spec best_block() :: Block
  def best_block() do
    Persistence.best_block()
  end

  @spec validate_block(Block) :: Boolean
  def validate_block(block) do
    BlockValidator.validate(block)
  end
 
  @doc """
    EsprezzoCore.Blockchain.Settlement.CoreChain.reinitialize()
  """
  def reinitialize() do
    Persistence.clear_blocks()
    gb = genesis_block()
    case Persistence.persist_block(gb) do
      {:ok, _} -> {:ok}
      {:error, _} -> {:error}
    end
  end


  @doc """
    Build Genesis Block
    gb = EsprezzoCore.Blockchain.Settlement.CoreChain.genesis_block
  """
  def genesis_block do
    %Block{
      txns: genesis_txns,
      header: %BlockHeader{
        version: 0,
        previous_hash: "0x",
        txns_merkle_root: "0x",
        timestamp: :os.system_time(:seconds)
      }
    } 
  end

  @doc """
  t = EsprezzoCore.Blockchain.Settlement.CoreChain.genesis_txns |> List.first
  """
  def genesis_txns do
  [
    %Transaction{ 
      version: 0,
      timestamp: :os.system_time(:seconds),
      # Coinbase txn
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
  end

  def sign_transaction(txn) do
    # hash transaction for script signature
  end

end
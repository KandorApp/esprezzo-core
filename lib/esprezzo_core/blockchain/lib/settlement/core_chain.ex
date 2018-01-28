defmodule EsprezzoCore.Blockchain.Settlement.CoreChain do
  require IEx
  alias EsprezzoCore.BlockChain.Settlement.Structs.{Block, BlockHeader, Transaction}
  alias EsprezzoCore.BlockChain.Settlement.BlockValidator
  alias EsprezzoCore.Blockchain.Persistence
  alias EsprezzoCore.Blockchain.Forger
  alias EsprezzoCore.Crypto.Hash

  @doc """
    EsprezzoCore.Blockchain.Settlement.CoreChain.reinitialize()
  """
  # def reinitialize() do
  #   Persistence.clear_blocks()
  #   genesis_block = Forger.forge_genesis_block()
  #   case Persistence.persist_block(genesis_block) do
  #     {:ok, _} -> {:ok}
  #     {:error, _} -> {:error}
  #   end
  # end

  @doc"""
    Create template to forge new block
  """
  def block_template do
    %Block{
      txns: [],
      header: %BlockHeader{
        version: 0,
        previous_hash: "0x",
        txns_merkle_root: "0x",
        timestamp: :os.system_time(:seconds),
        nonce: 0
      }
    } 
  end

  def txns_template do
    # get best block
    # find coinbase address
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


  @spec best_block() :: Block
  def best_block() do
    Persistence.best_block()
  end

  @spec validate_block(Block) :: Boolean
  def validate_block(block) do
    BlockValidator.validate(block)
  end

end
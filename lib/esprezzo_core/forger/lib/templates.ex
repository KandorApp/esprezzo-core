defmodule EsprezzoCore.Forger.Templates do
  require IEx
  require Logger

  alias EsprezzoCore.Blockchain
  alias EsprezzoCore.Blockchain.Settlment.Transactions
  alias EsprezzoCore.BlockChain.Settlement.Structs.{BlockHeader, Block, Transaction}
  
  @doc """
    Create template to forge new block
  """
  def block_template do
    best_block = Blockchain.best_block()
    block_number = best_block.block_number + 1
    Logger.warn "Forging block for height: #{block_number}"
    gen_timestamp = :os.system_time(:seconds)
    %Block{
      txns: [],
      timestamp: gen_timestamp,
      block_number: block_number,
      header: %BlockHeader{
        version: 0,
        previous_hash: best_block.header_hash,
        txns_merkle_root: "0x",
        timestamp: gen_timestamp,
        nonce: 0
      }
    } 
    |> Map.put(:txns, coinbase_txn_template())
    |> Transactions.write_merkle_root_to_block_header()
  end

  @doc """
    t = EsprezzoCore.Blockchain.Settlement.CoreChain.genesis_txns |> List.first
  """
  @spec coinbase_txn_template :: Transaction.t
  def coinbase_txn_template do
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

  def txns_template do
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

end
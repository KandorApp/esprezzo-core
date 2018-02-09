defmodule EsprezzoCore.BlockChain.Settlement.Structs.Block do

  alias EsprezzoCore.BlockChain.Settlement.Structs.BlockHeader
  
  @type t :: %__MODULE__{
    header: BlockHeader.t,
    txn_count: Integer.t,
    txns: List.t,
    header_hash: String.t,
    timestamp: Integer.t,
    nonce: Integer.t,
    meta: String.t,
    block_number: Integer.t
  }

  @derive [Poison.Encoder]
  defstruct [
    :header,
    :txn_count,
    :txns,
    :header_hash,
    :timestamp,
    :nonce,
    :meta,
    :block_number
  ]
  
end
defmodule EsprezzoCore.BlockChain.Settlement.Structs.Block do

  alias EsprezzoCore.BlockChain.Settlement.Structs.BlockHeader
  
  @type t :: %__MODULE__{
    header: BlockHeader.t,
    txn_count: Integer.t,
    txns: List.t,
    header_hash: String.t,
    timestamp: Integer.t
  }

  @derive [Poison.Encoder]
  defstruct [
    :header,
    :txn_count,
    :txns,
    :header_hash,
    :timestamp
  ]
  
end
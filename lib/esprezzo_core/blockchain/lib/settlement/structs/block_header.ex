defmodule EsprezzoCore.BlockChain.Settlement.Structs.BlockHeader do
  
  @type t :: %__MODULE__{
    version: Integer.t,
    previous_hash: String.t,
    txns_merkle_root: String.t,
    timestamp: Integer.t,
    nonce: Integer.t,
    difficulty_target: Integer.t
  }

  @derive [Poison.Encoder]
  defstruct [
    :version,
    :previous_hash,
    :txns_merkle_root,
    :timestamp,
    :nonce,
    :difficulty_target
  ]

end
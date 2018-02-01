defmodule EsprezzoCore.BlockChain.Settlement.Structs.Transaction do
  
  @type t :: %__MODULE__{
    version: Integer.t,
    txid: String.t,
    timestamp: Integer.t,
    vin: List.t,
    vout: List.t,
    meta: :String.t
  }

  @derive [Poison.Encoder]
  defstruct [
    :version,
    :txid,
    :timestamp,
    :vin,
    :vout,
    :meta
  ]

end
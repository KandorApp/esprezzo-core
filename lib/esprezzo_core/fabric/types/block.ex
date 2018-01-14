defmodule EsprezzoCore.Fabric.Types.Block do

  @type t :: %__MODULE__{
    index: String.t,
    previous_hash: String.t,
    timestamp: Map.t,
    data: String.t,
    nonce: String.t,
    hash: String.t
  }

  @derive [Poison.Encoder]
  defstruct [
    :index,
    :previous_hash,
    :timestamp,
    :data,
    :nonce,
    :hash
  ]
    
end
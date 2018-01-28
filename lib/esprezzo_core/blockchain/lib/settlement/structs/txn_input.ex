defmodule EsprezzoCore.BlockChain.Settlement.Structs.TransactionInput do
  
  @type t :: %__MODULE__{
    txid: String.t,
    vout: Integer.t,
    script_sig: String.t
  }

  @derive [Poison.Encoder]
  defstruct [
    :txid,
    :vout,
    :script_sig # Unlocking script for prev output (how can a user prove they are authd to spend)
  ]
end
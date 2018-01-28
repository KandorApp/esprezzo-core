defmodule EsprezzoCore.BlockChain.Settlement.Structs.TransactionOutput do
  
  @type t :: %__MODULE__{
    val: Integer.t,
    locking_contract: String.t
  }

  @derive [Poison.Encoder]
  defstruct [
    :val,
    :locking_contract
  ]

end
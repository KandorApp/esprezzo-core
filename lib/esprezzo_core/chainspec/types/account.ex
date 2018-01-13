defmodule EsprezzoCore.ChainSpec.Account do
  
  defstruct [:_id, :balance]

  def __build__(_id, balance) do
    %__MODULE__{_id: _id, balance: balance}
  end

  @type t :: %__MODULE__{
    _id: String.t,
    balance: integer
  }

end
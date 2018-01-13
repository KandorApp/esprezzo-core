defmodule EsprezzoCore.ChainSpec do
  
  alias EsprezzoCore.ChainSpec.Account

  defstruct [:name, :c_engine, :params, :genesis, :accounts]

  @type t :: %__MODULE__{
    name: String.t,
    c_engine: String.t,
    params: Map.t,
    genesis: String.t,
    accounts: [Account.t]
  }

end
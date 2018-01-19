defmodule EsprezzoCore.WireProtocol.Messages.Status do
  @moduledoc"""
  Command payload definition for Status Message
  """
    @type t :: %__MODULE__{
      protocolVersion: String.t,
      networkId: String.t,
      bestHash: String.t,
      genesisHash: String.t
    }
  
    @derive [Poison.Encoder]
    defstruct [
      :protocolVersion,
      :networkId,
      :bestHash,
      :genesisHash
    ]
    
  end
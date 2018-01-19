defmodule EsprezzoCore.WireProtocol.Messages.NewBlockHashes do
  @moduledoc"""
  Command payload definition for NewBlockHashes Message
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
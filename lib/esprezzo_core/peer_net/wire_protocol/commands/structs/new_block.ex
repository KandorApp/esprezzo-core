defmodule EsprezzoCore.WireProtocol.Commands.NewBlock do
  @moduledoc"""
  Command payload definition for NewBlock/0x04
  """ 
    @type t :: %__MODULE__{
      command: String.t,
      p2pVersion: String.t,
      clientId: String.t,
      listenPort: String.t,
      nodeId: String.t,
      blockData: Map.t
    }
  
    @derive [Poison.Encoder]
    defstruct [
      :command,
      :p2pVersion,
      :clientId,
      :listenPort,
      :nodeId,
      :blockData
    ]
  
    def build(block) do
      %__MODULE__{:command => "NEW_BLOCK", blockData: block}
    end
      
  end
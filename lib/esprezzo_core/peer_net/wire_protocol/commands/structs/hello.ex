defmodule EsprezzoCore.WireProtocol.Commands.Hello do
@moduledoc"""
Command payload definition for Hello/0x00
""" 

  @type t :: %__MODULE__{
    p2pVersion: String.t,
    clientId: String.t,
    listenPort: String.t,
    nodeId: String.t
  }

  @derive [Poison.Encoder]
  defstruct [
    :p2pVersion,
    :clientId,
    :listenPort,
    :nodeId
  ]
    
end
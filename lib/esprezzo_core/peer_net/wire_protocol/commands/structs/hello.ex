defmodule EsprezzoCore.WireProtocol.Commands.Hello do
@moduledoc"""
Command payload definition for Hello/0x00
""" 

  @type t :: %__MODULE__{
    command: String.t,
    p2pVersion: String.t,
    clientId: String.t,
    listenPort: String.t,
    nodeId: String.t
  }

  @derive [Poison.Encoder]
  defstruct [
    :command,
    :p2pVersion,
    :clientId,
    :listenPort,
    :nodeId
  ]

  def build do
    %__MODULE__{:command => "HELLO", p2pVersion: 1}
  end
    
end
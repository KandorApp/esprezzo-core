defmodule EsprezzoCore.WireProtocol.Commands.Disconnect do
  @moduledoc"""
  Command payload definition for Disconnect/0x01
  """ 
  
    @type t :: %__MODULE__{
      reason: String.t
    }
  
    @derive [Poison.Encoder]
    defstruct [
      :reason
    ]
      
  end
defmodule EsprezzoCore.WireProtocol.Commands.Ping do
  @moduledoc"""
  Command payload definition for Ping/0x02
  """ 

  @type t :: %__MODULE__{
    command: String.t
  }

  @derive [Poison.Encoder]
  defstruct [
    :command
  ]
    
  def build do
    %__MODULE__{:command => "PING"}
  end
  
end
defmodule EsprezzoCore.WireProtocol.Commands.Pong do
  @moduledoc"""
  Command payload definition for Pong/0x03
  """ 

  @type t :: %__MODULE__{
    command: String.t
  }

  @derive [Poison.Encoder]
  defstruct [
    :command
  ]
    
  def build do
    %__MODULE__{:command => "PONG"}
  end
  
end
defmodule EsprezzoCore.WireProtocol.Commands.Status do
  @moduledoc"""
  Command payload definition for Hello/0x00
  """ 
  
  @type t :: %__MODULE__{
    command:  String.t
  }

  @derive [Poison.Encoder]
  defstruct [
    :command
  ]
    
  def build do
    %__MODULE__{:command => "STATUS"}
  end

end
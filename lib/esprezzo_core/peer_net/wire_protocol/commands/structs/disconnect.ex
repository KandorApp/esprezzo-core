defmodule EsprezzoCore.WireProtocol.Commands.Disconnect do
  @moduledoc"""
  Command payload definition for Disconnect/0x01
  """ 
  
  @type t :: %__MODULE__{
    command: String.t,
    reason: String.t
  }

  @derive [Poison.Encoder]
  defstruct [
    :command,
    :reason
  ]
    
  def build do
    %__MODULE__{:command => "DISCONNECT", :reason => "version_mismatch"}
  end

end
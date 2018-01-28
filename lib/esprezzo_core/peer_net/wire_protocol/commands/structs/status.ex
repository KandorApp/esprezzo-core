defmodule EsprezzoCore.WireProtocol.Commands.Status do
  @moduledoc"""
  Command payload definition for Hello/0x00
  """ 
  
  @type t :: %__MODULE__{
    command:  String.t,
    protocol_version: String.t,
    network_id: Integer.t,
    best_hash: String.t,
    genesis_hash: String.t
  }

  @derive [Poison.Encoder]
  defstruct [
    :command,
    :protocol_version,
    :network_id,
    :best_hash,
    :genesis_hash
  ]
    
  def build do
    %__MODULE__{
      :command => "STATUS",
      :protocol_version => "0x00",
      :network_id => 1
    }
  end

end
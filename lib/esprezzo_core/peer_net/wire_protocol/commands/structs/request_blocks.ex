defmodule EsprezzoCore.WireProtocol.Commands.RequestBlocks do
  @moduledoc """
  Command payload definition for RequestBlocks/0x05
  """ 
    @type t :: %__MODULE__{
      command: String.t,
      index: Integer.t
    }
  
    @derive [Poison.Encoder]
    defstruct [
      :command,
      :index
    ]
  
    def build(index) do
      %__MODULE__{:command => "REQUEST_BLOCKS", index: index}
    end
      
  end
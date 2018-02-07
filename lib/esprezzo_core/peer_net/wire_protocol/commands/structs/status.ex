defmodule EsprezzoCore.WireProtocol.Commands.Status do
  require IEx
  @moduledoc """
  Command payload definition for Hello/0x00
  """ 
  alias EsprezzoCore.Blockchain
  alias EsprezzoCore.PeerNet


  @type t :: %__MODULE__{
    command:  String.t,
    protocol_version: String.t,
    network_id: Integer.t,
    best_hash: String.t,
    genesis_hash: String.t,
    block_height: Integer.t,
    node_uuid: String.t
  }

  @derive [Poison.Encoder]
  defstruct [
    :command,
    :protocol_version,
    :network_id,
    :best_hash,
    :genesis_hash,
    :block_height,
    :node_uuid
  ]
    
  def build do
    %__MODULE__{
      :command => "STATUS",
      :protocol_version => "0x00",
      :network_id => 1,
      :best_hash => Blockchain.CoreMeta.best_block().header_hash,
      :genesis_hash => Blockchain.CoreMeta.genesis_block().header_hash,
      :block_height => Blockchain.current_height(),
      :node_uuid => PeerNet.local_node_uuid()
    }
  end

end
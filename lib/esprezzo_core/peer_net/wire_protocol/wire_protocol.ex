defmodule EsprezzoCore.PeerNet.WireProtocol do
  
  def is_version_compatible?(remote_version \\ 1) do
    case remote_version do
      1 -> true
      _ -> false
    end
  end

  def generate_node_uuid do
    SecureRandom.uuid
  end

end
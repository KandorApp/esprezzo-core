defmodule EsprezzoCore.PeerNet.Protocols do
  use Rustler, otp_app: :esprezzo_core, crate: "peernet_protocols"
  
  @doc"""
  EsprezzoCore.PeerNet.Protocols.map_entries_sorted(%{"d" => 0, "a" => 1, "b" => 7, "e" => 4, "c" => 6})
  """
  def map_entries_sorted(x), do: err()
  
  @doc"""
  EsprezzoCore.PeerNet.Protocols.get_definition()
  """
  def get_definition(), do: err()

  defp err() do
    throw EsprezzoCore.PeerNet.NifNotLoadedError
  end

end

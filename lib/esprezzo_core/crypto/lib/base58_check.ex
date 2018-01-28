defmodule EsprezzoCore.Crypto.Base58Check do
  alias EsprezzoCore.Crypto.Base58

  @doc """
  EsprezzoCore.Crypto.Base58Check.encode(<<0x00>>, 
    <<0x01, 0x09, 0x66, 0x77, 0x60,
      0x06, 0x95, 0x3D, 0x55, 0x67,
      0x43, 0x9E, 0x5E, 0x39, 0xF8, 
      0x6A, 0x0D, 0x27, 0x3B, 0xEE>>)
  """

  def encode(data, version) do
    version <> data <> checksum(data, version)
    |> Base58.encode
  end

  defp checksum(data, version) do
    version <> data
    |> sha256
    |> sha256
    |> split
  end

  defp split(<< hash :: bytes-size(4), _ :: bits >>), do: hash

  defp sha256(data), do: :crypto.hash(:sha256, data)

end


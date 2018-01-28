defmodule EsprezzoCore.Crypto do
  alias EsprezzoCore.Crypto.Hash
  alias EsprezzoCore.Crypto.Base58
  @doc """
  EsprezzoCore.Crypto.sign(private_key, hex_message)
  """
  def sign(private_key, hex_data) do
    :crypto.sign(:ecdsa, :sha256, hex_data, [private_key, :secp256k1])
  end

  def verify(public_key, signature, hex_data) do
    :crypto.verify(:ecdsa, :sha256, hex_data, signature, [public_key, :secp256k1])
  end

  
end
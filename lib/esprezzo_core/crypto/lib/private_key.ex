defmodule EsprezzoCore.Crypto.PrivateKey do
  require Logger
  require IEx
  alias EsprezzoCore.Crypto.Base58Check
  
  @n :binary.decode_unsigned(<<
  0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
  0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE,
  0xBA, 0xAE, 0xDC, 0xE6, 0xAF, 0x48, 0xA0, 0x3B,
  0xBF, 0xD2, 0x5E, 0x8C, 0xD0, 0x36, 0x41, 0x41
  >>)

  @doc"""
  EsprezzoCore.Crypto.PrivateKey.generate
  Generate a 32byte(256bit) random private key
  """
  def generate do
    # private_key = :crypto.strong_rand_bytes(32)
    words = EsprezzoCore.Crypto.Mnemonic.generate()
    Logger.warn words
    # should output :crypto.strong_rand_bytes(32) |> is_binary == true
    # byte_length should be 32
    # bit_length should be 256
    private_key = EsprezzoCore.Crypto.Mnemonic.mnemonic_to_entropy(words)
    case valid?(private_key) do
      true  -> private_key
      false -> generate
    end
  end

  @doc"""
  Generate a 32byte(256bit) random private key
  private_key = EsprezzoCore.Crypto.PrivateKey.generate
  public_key = EsprezzoCore.Crypto.PrivateKey.to_public_key(private_key)
  """
  def to_public_key(private_key) do
    :crypto.generate_key(:ecdh, :crypto.ec_curve(:secp256k1), private_key)
    |> elem(0)
  end

  @doc"""
  privkey = EsprezzoCore.Crypto.PrivateKey.generate
  pubkey  = EsprezzoCore.Crypto.PrivateKey.to_public_key(privkey)
  pubhash  = EsprezzoCore.Crypto.PrivateKey.to_public_hash(pubkey)
  """
  def to_public_hash(private_key) do
    private_key
    |> to_public_key
    |> hash(:sha256)
    |> hash(:ripemd160)
  end

  @doc"""
  privkey = EsprezzoCore.Crypto.PrivateKey.generate
  pubkey  = EsprezzoCore.Crypto.PrivateKey.to_public_key(privkey)
  pubhash  = EsprezzoCore.Crypto.PrivateKey.to_public_hash(pubkey)
  pub_address = EsprezzoCore.Crypto.PrivateKey.to_public_address(pubhash)
  """
  def to_public_address(private_key, version \\ <<0x00>>) do
    private_key
    |> to_public_hash
    |> Base58Check.encode(version)
  end

  defp valid?(key) when is_binary(key) do
    key
    |> :binary.decode_unsigned
    |> valid?
  end
  defp valid?(key) when key > 1 and key < @n, do: true
  defp valid?(_), do: false

  defp hash(data, algorithm), do: :crypto.hash(algorithm, data)


end
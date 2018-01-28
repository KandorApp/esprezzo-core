defmodule EsprezzoCore.Crypto.OpenSSL do
  
  def generate_rsa() do
    {pem, 0} = System.cmd "openssl", ["genrsa","2048"]
    {:RSAPrivateKey, :'two-prime', n , e, d, _p, _q, _e1, _e2, _c, _other} = pem
    |> :public_key.pem_decode |> List.first |> :public_key.pem_entry_decode
    {e, n, d}
  end

  def generate_pem do
    keys |>
    entity_from_keys |>
    der_encode_entity |>
    pem_encode_der
  end
  defp keys, 
    do: :crypto.generate_key(:ecdh, :secp256k1)
  defp entity_from_keys({public, private}) do
    {:ECPrivateKey,
      1,
      :binary.bin_to_list(private),
      {:namedCurve, {1, 3, 132, 0, 10}},
      {0, public}}
  end       
  defp der_encode_entity(ec_entity), 
    do: :public_key.der_encode(
      :ECPrivateKey, 
      ec_entity)
  defp pem_encode_der(der_encoded), 
    do: :public_key.pem_encode(
      [{:ECPrivateKey, 
        der_encoded,
        :not_encrypted}])

end
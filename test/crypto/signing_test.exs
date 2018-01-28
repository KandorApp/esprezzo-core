defmodule EsprezzoCore.SigningTest do
  use ExUnit.Case
  require IEx
  alias EsprezzoCore.Crypto
  alias EsprezzoCore.Crypto.PrivateKey
  alias EsprezzoCore.BlockChain.Settlement.Structs.{Block, BlockHeader, Transaction}

  @private_key_hex "A170A8A285027032B851D39604609F7367FCE9545F496D350413799FA118E647"
  @private_key_bin <<161, 112, 168, 162, 133, 2, 112, 50, 184, 81, 211, 150, 4, 96, 159, 115, 103,
  252, 233, 84, 95, 73, 109, 53, 4, 19, 121, 159, 161, 24, 230, 71>>

  @public_key_hex "0469DCEDA0E2949E503E77DA6AE6342727977EB15AB4CB8CC10EB2FBED69738BEDC2386D34DE9490F89802D8CD698D945BA0E2992D267BD0BA9C20D63225B625D8"

  @txn_data [
    %Transaction{ 
      "version": 0,
      # Coinbase txn
      "vin": [
        %{
          "txid": "0x00",
          "vout": "0x00",
          "script_sig": "0x"
        }
      ],
      "vout": [
        %{
          "val": "100000000",
          "locking_contract": "OP_DUP OP_HASH160 1Fv1regg69W4AXhfbnFKR418qT8SXhhxRG OP_EQUALVERIFY OP_CHECKSIG" 
        }
      ]
    }
  ] |> List.first |> Map.delete(:__struct__)

  @txn_data_hex "7B22766F7574223A5B7B2276616C223A22313030303030303030222C226C6F636B696E675F636F6E7472616374223A224F505F445550204F505F484153483136302031467631726567673639573441586866626E464B5234313871543853586868785247204F505F455155414C564552494659204F505F434845434B534947227D5D2C2276696E223A5B7B22766F7574223A2230783030222C2274786964223A2230783030222C227363726970745F736967223A223078227D5D2C2276657273696F6E223A307D"
 
  test "bin and hex private keys match" do
    @private_key_hex |> Base.decode16() == @private_key_bin
  end

  test "correctly creates pubkey from privkey with ecdsa" do
    assert PrivateKey.to_public_key(@private_key_bin) |> Base.encode16() == @public_key_hex
  end

  test "correctly decodes txn with native atoms" do
    {:ok, json} = Poison.encode(@txn_data)
    assert @txn_data == Poison.decode!(json, keys: :atoms)
  end

  test "correctly creates and verifies signature" do
    private_key = PrivateKey.generate
    public_key  = PrivateKey.to_public_key(private_key)
    signature = Crypto.sign(private_key, @txn_data_hex)
    txn_data_hex = @txn_data_hex
    assert Crypto.verify(public_key, signature, txn_data_hex)
  end

  test "correctly fail signature verification" do
    private_key_1 = PrivateKey.generate
    private_key_2 = PrivateKey.generate
    public_key_1  = PrivateKey.to_public_key(private_key_1)
    public_key_2  = PrivateKey.to_public_key(private_key_2)
    signature = Crypto.sign(private_key_1, @txn_data_hex)
    assert Crypto.verify(public_key_1, signature, @txn_data_hex)
    refute Crypto.verify(public_key_2, signature, @txn_data_hex)
  end

  test "correctly decodes and verifies signature with public key and private keys stored as Base16" do
    private_key_hex = "A170A8A285027032B851D39604609F7367FCE9545F496D350413799FA118E647"
    public_key_hex = "0469DCEDA0E2949E503E77DA6AE6342727977EB15AB4CB8CC10EB2FBED69738BEDC2386D34DE9490F89802D8CD698D945BA0E2992D267BD0BA9C20D63225B625D8"
    private_key = Base.decode16!(private_key_hex)
    public_key = Base.decode16!(public_key_hex)
    signature = Crypto.sign(private_key, @txn_data_hex)
    txn_data_hex = @txn_data_hex
    assert Crypto.verify(public_key, signature, txn_data_hex)
  end

end
 
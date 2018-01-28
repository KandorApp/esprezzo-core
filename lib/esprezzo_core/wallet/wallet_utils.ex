defmodule EsprezzoCore.WalletUtils do
  
  @doc"""
  EsprezzoCore.Wallet.create
  """
  def create do
    privkey = EsprezzoCore.Crypto.PrivateKey.generate
    pubkey  = EsprezzoCore.Crypto.PrivateKey.to_public_key(privkey) |> Base.encode16()
    pubhash  = EsprezzoCore.Crypto.PrivateKey.to_public_hash(pubkey) |> Base.encode16()
    pub_address = EsprezzoCore.Crypto.PrivateKey.to_public_address(pubhash)  
  end
  
end

"""
Recovery Phrase: wasp link grape original bleak heart cat awful design course mention airport diagram melody play sugar island hazard slam dumb safe always bomb quiz

Private key:
F79041974E5178D488F0853BC62A2C02C3CF152996C6766D3F2C21FBE00F064D

public key: 0406D6077919B21F78F23FA1CEB9EC72D0D6E5A8A2B9FC32890878A5A4C83F2DEFD5257A7DBA6E783CADEE822318721E3FC9251903E3724A5F7CA035C6535A0F67

public hash: C83CAD3840CEEAD9D12B2A55171B71CEDF9EF14D

public address: 1Fv1regg69W4AXhfbnFKR418qT8SXhhxRG
"""
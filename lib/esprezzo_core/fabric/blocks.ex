defmodule EsprezzoCore.Fabric.Blocks do
  
alias EsprezzoCore.Fabric.Types.Block



  @spec build_hash(Block.t) :: Block.t
  def build_hash(%Block{index: i, previous_hash: h, timestamp: ts, data: data, nonce: n}) do
    # "#{i}#{h}#{ts}#{BlockData.hash(data)}#{n}"
    # |> Crypto.hash(:sha256)
    # |> Base.encode16()
  end

end
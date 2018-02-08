defmodule EsprezzoCore.U do
  alias EsprezzoCore.Blockchain
  alias EsprezzoCore.Blockchain.Persistence.Schemas.Block
  alias EsprezzoCore.Blockchain.Persistence
  alias EsprezzoCore.Blockchain.Forger

  def fb(x) do
    Block.find(x)
  end

  def genblock do
    Persistence.genblock()
  end

  def frg() do
    Forger.toggle()
  end
end
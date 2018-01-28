defmodule EsprezzoCore.Blockchain.Forger do
  require Logger
  require IEx
  use GenServer
  alias EsprezzoCore.BlockChain.Settlement.Structs.{BlockHeader, Block}
  alias EsprezzoCore.Crypto.Hash
  alias EsprezzoCore.Crypto.Base58

  @target 100

  @doc"""
  Setup
  """
  def start_link(opts) do
    Logger.warn(fn ->
      "Started Forging Server"
    end)
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc"""
  Setup state Map
  """
  def init(state) do
    #schedule_forge(header)
    {:ok, %{}}
  end

  @doc """
  data = EsprezzoCore.Blockchain.Settlement.CoreChain.genesis_block  
  EsprezzoCore.Blockchain.Forger.forge_block(data.header)
  """
  def forge_block(header, nonce \\ 0, prev \\ []) do
    hash = create_header_hash(header, nonce)
    if Enum.member?(prev, hash) do
      Logger.error "COLLISION!!"
      :timer.sleep(10000)
    end
    case verify(hash) do
      true -> hash
      false -> 
        prev = [] ++ [hash]
        h = forge_block(header, nonce + 1, prev)
    end
  end

  def handle_info(:forge_block, state) do
    Logger.warn(fn ->
      "Forging New Block"
    end)
    #forge_block(header)
    #schedule_forge()
    {:noreply, state}
  end

  defp schedule_forge(header) do
   #Process.send_after(self(), {:forge_block, header}, 1000)
  end

  def verify(hash) do
    Logger.warn "HASH: #{hash}"
    #IEx.pry
    String.starts_with?(hash, "000000")
  end

  def create_header_hash(%BlockHeader{version: v, previous_hash: h, timestamp: ts, txns_merkle_root: mr}, nonce \\ 0) do  
    hash = "#{v}#{h}#{ts}#{mr}#{nonce}"
      |> Hash.sha256()
      |> String.downcase()
  end

end
defmodule EsprezzoCore.Blockchain.Forger do
  require Logger
  require IEx
  use GenServer
  alias EsprezzoCore.Crypto.Hash
  alias EsprezzoCore.Crypto.Base58
  alias EsprezzoCore.Blockchain
  alias EsprezzoCore.Blockchain.Settlement.CoreChain
  alias EsprezzoCore.BlockChain.Settlement.Structs.{BlockHeader, Block}
  alias EsprezzoCore.Blockchain.Settlement.CoreChain.Genesis
  alias EsprezzoCore.Blockchain.Forger.Hashery

  @target_diff 100000000000000000000000000000000000000000000000000000000000000000000000000
               
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
    state = Map.put(state, :pause, true)
    schedule_forge(state)
    {:ok, state}
  end


  def handle_info(:forge_block, state) do
    case state.pause do
      true ->
        Logger.warn "Forging Paused..."
      false ->
        Logger.warn(fn ->
          "Forging New Block"
        end)
        EsprezzoCore.Blockchain.Forger.Hashery.forge()
    end
    schedule_forge(state)
    {:noreply, state}
  end

  

  defp schedule_forge(state) do
    Process.send_after(self(), :forge_block, 10000)
  end
 
  @doc """
  EsprezzoCore.Blockchain.Forger.toggle()
  """
  def toggle() do
    GenServer.call(__MODULE__, :toggle, :infinity)
  end

  def handle_call(:toggle, _from, state) do
    state = case state.pause do
      false ->
        Map.put(state, :pause, true)
      true ->
        Map.put(state, :pause, false)  
    end
    {:reply, state, state}
  end
  
end
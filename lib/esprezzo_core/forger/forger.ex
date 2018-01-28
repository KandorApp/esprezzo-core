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
  alias EsprezzoCore.Forger.Templates
  alias EsprezzoCore.Blockchain.Persistence

  @target_diff 10000000000000000000000000000000000000000000000000000000000000000000000000
               
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
    state = Map.put(state, :pause, false)
    schedule_forge(state)
    {:ok, state}
  end


  @doc """
  EsprezzoCore.Blockchain.Forger.forge()
  """
  @spec forge() :: :ok | :error
  def forge() do
    block_candidate = forge_block_candidate(Templates.block_template())
    case Persistence.persist_block(block_candidate) do
      {:ok, block} -> 
        Logger.warn "Storing Block Candidate for height: #{Blockchain.current_height}"
        # update memchain
        EsprezzoCore.Blockchain.CoreMeta.push_block(block)        
        {:ok, block}
      {:error, changeset} ->
        Logger.error "Failed To Store Block Candidate for height: #{Blockchain.current_height + 1}"
        {:error, changeset}
    end
  end


  @doc """
    EsprezzoCore.Blockchain.Forger.forge_genesis_block()
  """
  def forge_genesis_block(block_data) do 

    {header_hash, nonce} = forge_block_hash(block_data.header, 0)
   
    header_data = block_data.header
      |> Map.put(:nonce, nonce)

    finished_block = block_data
      |> Map.put(:header_hash, header_hash)
      |> Map.put(:header, header_data)

    case Blockchain.block_is_valid?(finished_block) do
      true ->
        finished_block
      _ ->
        Logger.error "Forging Genesis Block Failed"
        IEx.pry
        false
    end
  end

  @doc """
    EsprezzoCore.Blockchain.Forger.forge_block(block_data)
  """
  def forge_block_candidate(block_data) do 

    {header_hash, nonce} = forge_block_hash(block_data.header, 0)
   
    header_data = block_data.header
      |> Map.put(:nonce, nonce)

    finished_block = block_data
      |> Map.put(:header_hash, header_hash)
      |> Map.put(:header, header_data)

    case Blockchain.block_is_valid?(finished_block) do
      true ->
        finished_block
      _ ->
        Logger.error "Forging Genesis Block Failed"
        IEx.pry
        false
    end
  end


  @doc """
    data = EsprezzoCore.Blockchain.Settlement.CoreChain.genesis_block  
    EsprezzoCore.Blockchain.Forger.forge_block_hash(data.header)
  """
  def forge_block_hash(header, nonce \\ nil, prev \\ []) do
    n = case nonce do
      nil -> Enum.random(0..10000000000000000000)
      _ -> nonce
    end
    hash = create_header_hash(header, n)
    if Enum.member?(prev, hash) do
      Logger.error "COLLISION!!"
      :timer.sleep(10000)
    end
    case verify(hash, n) do
      true -> {hash, n}
      false -> 
        prev = [] ++ [hash]
        forge_block_hash(header, n + 1, prev)
    end
  end

  def handle_info(:forge_block, state) do
    case state.pause do
      true ->
        Logger.warn "Forging Paused..."
      false ->
        Logger.warn(fn ->
          "Forging New Block"
        end)
        EsprezzoCore.Blockchain.Forger.forge()
    end
    schedule_forge(state)
    {:noreply, state}
  end

  @doc """
    Does something similar to String.starts_with?(hash, "0000")
    But with real numbers
  """
  @spec verify(String, Integer.t) :: Boolean.t
  def verify(hash, nonce) do
    {value, _} = Integer.parse(hash, 16)
    case value <= @target_diff do
      true ->
        Logger.warn "We have a winner!"
        Logger.warn "Target: #{@target_diff}"
        Logger.warn "Hash: #{hash}"
        Logger.warn "Hash Integer Val: #{value}"
        Logger.warn "Nonce: #{nonce}"
        true
      false -> 
        Logger.error "VALUE MISSED TARGET: #{nonce} : #{value}"
        Logger.error "VALUE MISSED TARGET BY: #{value - @target_diff}"
        false
    end
  end

  def create_header_hash(
    %BlockHeader{
      version: v, 
      previous_hash: h, 
      timestamp: ts, 
      txns_merkle_root: mr
      }, 
      nonce
    ) do  
    "#{v}#{h}#{ts}#{mr}#{nonce}"
      |> Hash.sha256()
      |> String.downcase()
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
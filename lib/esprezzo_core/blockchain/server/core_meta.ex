defmodule EsprezzoCore.Blockchain.CoreMeta do
  require Logger
  require IEx
  use GenServer
  alias EsprezzoCore.Blockchain.Persistence
  alias EsprezzoCore.Blockchain

  @doc """
    Setup
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Initialize PeerManager Process
  %{
    :core_blocks => []
  }
  """
  def init(opts) do
    Logger.warn(fn ->
      "Blockchain.CoreMeta.init"
    end)
    
    blocks = Persistence.load_chain()
    
    transactions = Persistence.load_transactions()
    
    block_txn_index = transactions
      |> Enum.reduce(%{}, fn (x, acc) -> 
        case Map.has_key?(acc, x.txid) do
          true ->
            Map.put(acc, x.block_hash,  acc ++ [x.txid])
          false ->
            Map.put(acc, x.block_hash, [x.txid])
        end
      end)

    transactions = Enum.reduce(transactions, %{}, fn (x, acc) -> 
      Map.put(acc, x.txid, x)
    end)

    Logger.warn "LOADED #{Enum.count(blocks)} BLOCKS FROM STORAGE"
    # Logger.warn "Starting network sync..."

    # Construct MemChain
    block_index = Enum.map(blocks, fn x -> x.header_hash end)
    blocks = Enum.reduce(blocks, %{}, fn (x, acc) -> 
      txns = Map.take(transactions, Map.get(block_txn_index, x.header_hash))
      x = Map.put(x, :transactions, txns)
      Map.put(acc, x.header_hash, x)
    end)

    {:ok, %{
      :block_index => block_index,
      :blocks => blocks,
      :transactions => transactions,
      :block_txn_index => block_txn_index
      }
    }
  end
 
  @doc """
    EsprezzoCore.Blockchain.CoreMeta.get_state
  """
  def get_state do
    GenServer.call(__MODULE__, :get_state, :infinity)
  end
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @doc """
    EsprezzoCore.Blockchain.CoreMeta.best_block
  """
  def best_block do
    GenServer.call(__MODULE__, :best_block, :infinity)
  end
  def handle_call(:best_block, _from, state) do
    top_index = state.block_index |> List.last
    top_block = Map.get(state.blocks, top_index)
    {:reply, top_block, state}
  end

  @doc """
    EsprezzoCore.Blockchain.CoreMeta.status
  """
  def status do
    GenServer.call(__MODULE__, :status, :infinity)
  end
  def handle_call(:status, _from, state) do
    Logger.warn "Block Index Height: #{Enum.count(state.block_index)}"
    Logger.warn "Block Map Height: #{Enum.count(state.blocks)}"
    Logger.warn "Txn Count: #{Enum.count(state.transactions)}"
    {:reply, nil, state}
  end

  @doc """
    EsprezzoCore.Blockchain.CoreMeta.push_block
  """
  def push_block(block) do
    GenServer.call(__MODULE__, {:push_block, block}, :infinity)
    GenServer.call(__MODULE__, :status, :infinity)
  end
  def handle_call({:push_block, block}, _from, state) do
    
    IEx.pry
    block_index = state.block_index ++ [block.header_hash]
  
    blocks = Map.put(state.blocks, block.header_hash, block)
    
    transactions = Enum.reduce(block.txns, state.transactions, fn (x, acc) -> 
      Map.put(acc, x.txid, x)
    end)

    block_txn_index = block.txns
    |> Enum.reduce(state.block_txn_index, fn (x, acc) -> 
      case Map.has_key?(acc, x.txid) do
        true ->
          Map.put(acc, x.block_hash,  acc ++ [x.txid])
        false ->
          Map.put(acc, x.block_hash, [x.txid])
      end
    end)

    state = state
      |> Map.put(:block_index, block_index)
      |> Map.put(:transactions, transactions)
      |> Map.put(:blocks, blocks)
      |> Map.put(:block_txn_index, block_txn_index)

    EsprezzoCore.PeerNet.PeerManager.notify_peers_with_new_block(block)
      
    {:reply, state, state}
  end


end
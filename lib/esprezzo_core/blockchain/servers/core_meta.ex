defmodule EsprezzoCore.Blockchain.CoreMeta do
  require Logger
  require IEx
  
  use GenServer

  alias EsprezzoCore.Blockchain.Persistence
  alias EsprezzoCore.Blockchain.ChainBuilder
  alias EsprezzoCore.BlockChain.Settlement.BlockValidator
  alias EsprezzoCore.Blockchain.Settlement.CoreChain.Genesis  
  
  @doc """
    Setup
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Initialize PeerManager Process
  %{
    :block_index -> List of existing blockhashes (in order)
    :txn_index -> List of existing txns
    :transactions -> Map of transactions keyed by txid
    :block_txn_index -> list of existing txids keyed by block
    :blocks -> Map of all blocks keyed by hash 
  }
  """
  def init(opts) do
    blocks = Persistence.load_chain()
    transactions = Persistence.load_transactions()
    case Enum.count(blocks) do
      cnt when cnt > 0 ->
        Logger.warn "More than zero blocks"
        block = List.first(blocks)
        case block.header_hash == Genesis.genesis_hash do
          true -> 
            Logger.warn "Genesis Block intact"
          false -> 
            Logger.warn "Genesis Block invalid.. reloading"
            Genesis.reinitialize()
        end
      0 ->
        Logger.warn "Genesis Block Exists"
    end
    Logger.warn "LOADED #{Enum.count(blocks)} BLOCKS FROM STORAGE"
    block_index = ChainBuilder.build_block_index(blocks)
    txn_index = ChainBuilder.build_txn_index(transactions)
    block_txn_index = ChainBuilder.build_transactions_by_block_index(transactions)
    transaction_map = ChainBuilder.build_transaction_map(transactions)
    blockchain = ChainBuilder.build_blockchain(blocks, transaction_map, block_txn_index)
    BlockValidator.validate_blocks(Map.values(blockchain))
    {:ok, %{
      :block_index => block_index,
      :txn_index => txn_index,
      :block_txn_index => block_txn_index,
      :transactions => transaction_map,
      :blocks => blockchain
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
    EsprezzoCore.Blockchain.CoreMeta.refresh
  """
  def refresh do
    GenServer.call(__MODULE__, :refresh, :infinity)
  end
  def handle_call(:refresh, _from, state) do
    {:ok, state} = init([])
    {:reply, true, state}
  end

  @doc """
    EsprezzoCore.Blockchain.CoreMeta.block_exists?("00001b685354953b0ccadb721f858834fdd208888fdf358598da0e8aa8a70b20")
  """
  def block_exists?(hash) do
    GenServer.call(__MODULE__, {:block_exists, hash}, :infinity)
  end
  def handle_call({:block_exists, hash}, _from, state) do
    res = Enum.member?(state.block_index, hash)
    {:reply, res, state}
  end

  def validate_blocks() do
    GenServer.call(__MODULE__, :validate_blocks, :infinity)
  end
  def handle_call({:validate_blocks, hash}, _from, state) do
    BlockValidator.validate_blocks(state.blocks)
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
    EsprezzoCore.Blockchain.CoreMeta.height
  """
  def height do
    GenServer.call(__MODULE__, :height, :infinity)
  end
  def handle_call(:height, _from, state) do
    c = Enum.count(state.block_index)
    {:reply, c, state}
  end

   @doc """
    EsprezzoCore.Blockchain.CoreMeta.latest_timestamp()
  """
  def latest_block_overview do
    GenServer.call(__MODULE__, :latest_block_overview, :infinity)
  end
  def handle_call(:latest_block_overview, _from, state) do
    h = state.block_index |> List.last
    latest_block = Map.get(state.blocks, h)
    txn_count = latest_block.txns |> Enum.count
    ov = Map.take(latest_block, [:timestamp, :header_hash])
    ov = Map.put(ov, :txn_count, txn_count)
    {:reply, ov, state}
  end

  @doc """
    EsprezzoCore.Blockchain.CoreMeta.push_block
  """
  def push_block(block) do
    GenServer.call(__MODULE__, {:push_block, block}, :infinity)
    GenServer.call(__MODULE__, :status, :infinity)
  end
  def handle_call({:push_block, block}, _from, state) do
  
    case Enum.member?(state.block_index, block.header_hash) do
      true -> 
        Logger.warn "Block #{block.header_hash} already exists in index // NOOP"
      false -> 
        block_index = state.block_index ++ [block.header_hash]

        txn_index = case state.txn_index  do
          [] -> [ChainBuilder.build_txn_index(block.txns)]
          nil -> [ChainBuilder.build_txn_index(block.txns)]
          transaction_index ->
            transaction_index ++ ChainBuilder.build_txn_index(block.txns)
        end
        
        
        blocks = Map.put(state.blocks, block.header_hash, block)
        
        transactions = Enum.reduce(block.txns, state.transactions, fn (x, acc) -> 
          Map.put(acc, x.txid, x)
        end)
        
        block_txn_index = block.txns
          |> Enum.reduce(state.block_txn_index, fn (x, acc) -> 
            case Map.has_key?(acc, x.txid) do
              true ->
                Map.put(acc, x.block_hash, acc ++ [x.txid])
              false ->
                Map.put(acc, x.block_hash, [x.txid])
            end
          end)
        
        state = state
          |> Map.put(:block_index, block_index)
          |> Map.put(:txn_index, txn_index)
          |> Map.put(:block_txn_index, block_txn_index)
          |> Map.put(:transactions, transactions)
          |> Map.put(:blocks, blocks)
          
        EsprezzoCore.PeerNet.PeerManager.notify_peers_with_new_block(block)
    end
      
    {:reply, state, state}
  end


  def genesis_block do
    GenServer.call(__MODULE__, :genesis_block, :infinity)
  end
  def handle_call(:genesis_block, _from, state) do
    first_idx = state.block_index |> List.first
    genesis_block = Map.get(state.blocks, first_idx)
    {:reply, genesis_block, state}
  end

end
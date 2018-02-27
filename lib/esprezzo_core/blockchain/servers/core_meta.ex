defmodule EsprezzoCore.Blockchain.CoreMeta do
  require Logger
  require IEx
  
  use GenServer

  alias EsprezzoCore.Blockchain
  alias EsprezzoCore.PeerNet.PeerManager
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
            IEx.pry
            blocks = Persistence.load_chain()
        end
      _ ->
        Logger.warn "Genesis block not available.. reloading"
        Genesis.reinitialize()
        blocks = Persistence.load_chain()
    end
    
    Logger.warn "LOADED #{Enum.count(blocks)} BLOCKS FROM STORAGE"
    block_index = ChainBuilder.build_block_index(blocks)
    txn_index = ChainBuilder.build_txn_index(transactions)
    block_txn_index = ChainBuilder.build_transactions_by_block_index(transactions)
    transaction_map = ChainBuilder.build_transaction_map(transactions)
    blockchain = ChainBuilder.build_blockchain(blocks, transaction_map, block_txn_index)
    block_height_index = ChainBuilder.build_block_height_index(Map.values(blockchain))
    
    genesis_hash = block_index
      |> List.first()
  
    blocks = blockchain
      |> Map.delete(genesis_hash) 
      |> Map.values()
  
    BlockValidator.validate_chain(blocks, block_height_index)
    Logger.warn "Chain State Loaded"
    
    schedule_status_display()
    
    {:ok, %{
      :block_index => block_index,
      :txn_index => txn_index,
      :block_txn_index => block_txn_index,
      :transactions => transaction_map,
      :blocks => blockchain,
      :block_height_index => block_height_index
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
    EsprezzoCore.Blockchain.CoreMeta.get_block_height_index()
  """
  def get_block_height_index do
    GenServer.call(__MODULE__, :get_block_height_index, :infinity)
  end
  def handle_call(:get_block_height_index, _from, state) do
    {:reply, state.block_height_index, state}
  end

  @doc """
    EsprezzoCore.Blockchain.CoreMeta.get_block_index()
  """
  def get_block_index do
    GenServer.call(__MODULE__, :get_block_index, :infinity)
  end
  def handle_call(:get_block_index, _from, state) do
    {:reply, state.block_index, state}
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

  @doc """
    EsprezzoCore.Blockchain.CoreMeta.validate_blocks()
  """
  def validate_blocks() do
    GenServer.call(__MODULE__, :validate_blocks, :infinity)
    :ok
  end
  def handle_call(:validate_blocks, _from, state) do
    genesis_hash = state.block_index
    |> List.first()

  blocks = state.blocks
    |> Map.delete(genesis_hash) 
    |> Map.values()
    
    BlockValidator.validate_chain(blocks, state.block_height_index)
    {:reply, state, state}
  end

  @doc """
    EsprezzoCore.Blockchain.CoreMeta.get_block_at_height(23)
  """
  def get_block_at_height(idx) do
    GenServer.call(__MODULE__, {:get_block_at_height, idx}, :infinity)
  end
  def handle_call({:get_block_at_height, idx}, _from, state) do
    hash_key = Map.get(state.block_height_index, idx)
    block = Map.get(state.blocks, hash_key)
    {:reply, block, state}
  end


  @doc """
    EsprezzoCore.Blockchain.CoreMeta.get_n_blocks(0,5)
  """
  def get_n_blocks(start_index, count) do
    GenServer.call(__MODULE__, {:get_n_blocks, start_index, count}, :infinity)
  end
  def handle_call({:get_n_blocks, start_index, count}, _from, state) do
    range = start_index..(start_index + (count - 1))
    revblocks = Enum.reverse(state.block_height_index)
    headers = Map.take(revblocks, range)
    blocks = 
      Map.take(state.blocks, Map.values(headers))
      |> Map.values() 
      |> Enum.sort(&(&2.block_number <= &1.block_number))

    {:reply, blocks, state}
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
    Only way to add a block to the chain and to persistent storage
    DO NOT HANDLE VALIDATION HERE
  """
  def push_block(block, notify \\ false) do
    # GenServer.call(__MODULE__, :status, :infinity)
    GenServer.call(__MODULE__, {:push_block, block, notify}, :infinity)
  end
  def handle_call({:push_block, block, notify}, _from, state) do
    Logger.warn "Block Index Height: #{Enum.count(state.block_index)}"
    Logger.warn "Block Map Height: #{Enum.count(state.blocks)}"
    case Enum.member?(state.block_index, block.header_hash) do
      true -> 
        Logger.warn "Block #{block.header_hash} already exists in index // NOOP // Pausing..."
        {:reply, {:error, "exists"}, state}
        
      false -> 
        case Persistence.persist_block(block) do
          {:ok, block} -> 
            Logger.warn "Storing Block Candidate for height: #{Enum.count(state.block_index)}"
            Logger.warn "Adding Block #{block.header_hash}"
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
            
            block_height_index = Map.put(state.block_height_index, block.block_number, block.header_hash) 

            state = state
              |> Map.put(:block_index, block_index)
              |> Map.put(:txn_index, txn_index)
              |> Map.put(:block_txn_index, block_txn_index)
              |> Map.put(:transactions, transactions)
              |> Map.put(:blocks, blocks)
              |> Map.put(:block_height_index, block_height_index)

            if notify do
              PeerManager.notify_peers_with_new_block(block)
            end
          {:error, changeset} ->
            IEx.pry
            Logger.error "Failed To Store Block Candidate for height: #{Blockchain.current_height + 1}"
            {:error, changeset}
        end
      
        {:reply, :ok, state}

    end
      
  end

  @spec get_block(String.t) :: term
  def get_block(hash) do
    GenServer.call(__MODULE__, {:get_block, hash}, :infinity)
  end
  def handle_call({:get_block, hash}, _from, state) do
    block = Map.get(state.blocks, hash)
    {:reply, block, state}
  end

  @spec genesis_block() :: term
  def genesis_block do
    GenServer.call(__MODULE__, :genesis_block, :infinity)
  end
  def handle_call(:genesis_block, _from, state) do
    first_idx = state.block_index |> List.first
    genesis_block = Map.get(state.blocks, first_idx)
    {:reply, genesis_block, state}
  end

  @doc """
  """
  def handle_info(:display_status, state) do
    Logger.warn "Local Block Height: #{Enum.count(state.block_index)} // BlockChain Map Height: #{Enum.count(state.blocks)}"
    Logger.warn "Local Txn Count: #{Enum.count(state.transactions)}"
    schedule_status_display()
    {:noreply, state}
  end

  defp schedule_status_display() do
    Process.send_after(self(), :display_status, 5000)
  end  

end
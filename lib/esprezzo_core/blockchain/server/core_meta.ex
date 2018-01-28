defmodule EsprezzoCore.Blockchain.CoreMeta do
  @moduledoc"""
  Genserver container that aggregates and exposes 
  settlment ledger data
  """

  use GenServer
  require Logger
  require IEx
  
  @doc"""
  Setup
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc"""
  Initialize PeerManager Process
  %{
    :core_blocks => []
  }
  """
  def init(opts) do
    
    Logger.warn(fn ->
      "Blockchain.CoreMeta.init"
    end)
    {:ok, %{
      :blocks => []
      }
    }
  end
 
  def get_state do
    GenServer.call(__MODULE__, :get_state, :infinity)
  end

  

  # process messages
  @doc"""
  Example:

    iex> EsprezzoCore. get_state

  """
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end


end
defmodule EsprezzoCore.PeerNet.PeerTracker do
  @moduledoc"""
  Supervisor who's only job us to acts as a container
  for a group of peer connection processes
  """
  use Supervisor
  alias EsprezzoCore.PeerNet.Peer
  alias EsprezzoCore.PeerNet

  def start_link(config) do
    Supervisor.start_link(__MODULE__, config, name: __MODULE__)
  end

  @doc"""
  Attempts to connect to all default peers
  on initialization
  """
  def init(_config) do
    Supervisor.init([Peer], strategy: :simple_one_for_one)
  end

  def count_peers do
    Supervisor.count_children(__MODULE__).workers
  end

  def list_peers do
    __MODULE__
    |> Supervisor.which_children()
    |> Enum.map(fn {_, pid, _, _} -> pid end)
  end

  def add_peer(socket, transport) do
    Supervisor.start_child(__MODULE__, [[socket: socket, transport: transport]])
  end

  def remove_peer(pid) do
    Supervisor.terminate_child(__MODULE__, pid)
  end
  
end
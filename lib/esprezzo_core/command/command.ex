defmodule EsprezzoCore.Command do
  use GenServer
  alias EsprezzoCore.PeerNet
  
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc"""
  Initialize Command Worker
  """
  def init(opts) do
    PeerNet.bootstrap_connections()
    {:ok, []}
  end

end
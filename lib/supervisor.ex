defmodule EsprezzoCore.Supervisor do
  use Supervisor
  
  @quiet false

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :p2p_server_supervisor)
  end

  @doc"""
  Initialize Primary Supervisor
  """
  def init([]) do
    children = []
    unless @quiet do
      children = children ++ [ 
        worker(EsprezzoCore.PeerNet.Server, [[{:name, PeerNetServer},{:port, 30343}]], [id: "PeerNetServer1"]),       
        worker(EsprezzoCore.PeerNet.StateTracker, [[{:name, PeerStateTracker}]], [id: "PeerStateTracker"]),
        worker(EsprezzoCore.Command,[CommandWorker])
      ] 
    end
    supervise(children, strategy: :one_for_one)
  end

end
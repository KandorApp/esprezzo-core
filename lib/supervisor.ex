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
        worker(EsprezzoCore.PeerNet.TCPServer, [[{:name, PeerNetTCPServer},{:port, 30343}]], [id: "PeerNetTCPServer"]),       
        worker(EsprezzoCore.PeerNet.PeerTracker, [[{:name, PeerTracker}]], [id: "PeerTracker"]),
        worker(EsprezzoCore.PeerNet.PeerManager, [[{:name, PeerManager}]], [id: "PeerManager"])
      ] 
    end
    supervise(children, strategy: :one_for_one)
  end

end
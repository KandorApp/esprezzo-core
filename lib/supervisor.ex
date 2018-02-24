defmodule EsprezzoCore.Supervisor do
  use Supervisor
  require Logger
  alias EsprezzoCore.PeerNet.WireProtocol

  @quiet false 

  

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :p2p_server_supervisor)
  end

  @doc"""
  Initialize Primary Supervisor
  """
  def init([]) do
    node_uuid = WireProtocol.generate_node_uuid()
    Logger.warn(fn ->
      "Starting node with uuid #{node_uuid}"
    end)
    
    children = []
    unless @quiet do
      children = children ++ [ 
        worker(EsprezzoCore.Blockchain.CoreMeta, [%{name: CoreMeta}], [id: "CoreMeta"]),
        worker(EsprezzoCore.PeerNet.TCPServer, [[{:name, PeerNetTCPServer},{:port, 30343}, {:node_uuid, node_uuid}]], [id: "PeerNetTCPServer"]),       
        worker(EsprezzoCore.PeerNet.PeerSupervisor, [%{name: PeerSupervisor, node_uuid: node_uuid}], [id: "PeerSupervisor"]),
        worker(EsprezzoCore.PeerNet.PeerManager, [%{name: PeerManager, node_uuid: node_uuid}], [id: "PeerManager"]),
        worker(EsprezzoCore.Blockchain.Forger, [%{name: Forger}], [id: "ForgeManager"])
      ] 
    end
    supervise(children, strategy: :one_for_one)
  end


  
end
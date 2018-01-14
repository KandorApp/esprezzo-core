defmodule EsprezzoCore.Supervisor do
  use Supervisor
  
  @quiet false

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :p2p_server_supervisor)
  end


  # Callbacks
  def init([]) do
    children = []
    unless @quiet do
      children = children ++ [ 
        worker(EsprezzoCore.PeerNet.Server, [[{:name, PeerNetServer},{:port, 19876}]], [id: "PeerNetServer1"])       
      ] 
    end
    supervise(children, strategy: :one_for_one)
  end

end
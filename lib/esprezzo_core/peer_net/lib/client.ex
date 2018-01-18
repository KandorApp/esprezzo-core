defmodule EsprezzoCore.PeerNet.Client do
  require Logger
  require IEx
  alias EsprezzoCore.PeerNet.StateTracker
  alias EsprezzoCore.PeerNet.NetMeta

  @doc"""
  EsprezzoCore.PeerNet.Client.connect("127.0.0.1", 19876)
  """
  def connect(address, port) do
    [a,b,c,d] = String.split(address, ".")
      |> Enum.map(fn x -> 
          {n, _} = Integer.parse(x)
          n
        end )
    #opts = [:binary, :inet, active: true, packet: :line]
    # with {:ok, socket} = :gen_tcp.connect({a, b, c, d}, port, opts) do
    #   {:ok, pid} = StateTracker.add_peer(socket, :gen_tcp)
    #   :gen_tcp.controlling_process(socket, pid)
    #   {:ok, pid}
    # end
    tcp_options = [:binary, {:packet, 4}, :line, active: false, reuseaddr: true]
    case :gen_tcp.connect({a, b, c, d}, port, tcp_options) do
      {:ok, socket} ->  
        {:ok, pid} = StateTracker.add_peer(socket, :gen_tcp)
        :gen_tcp.controlling_process(socket, pid)
        {:ok, pid}
      {:error, reason} ->
        Logger.error( fn ->
          "Could not connect to remote host"
        end)
        {:error, reason}
    end

  end

  def connect_to_bootstrap_nodes do
    NetMeta.bootstrap_nodes
      |> Enum.map(fn x ->
        [ip, port] = String.split(x, ":")
        {port, _} = Integer.parse(port)
        __MODULE__.connect(ip, port)
    end)
  end

end
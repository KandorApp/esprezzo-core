defmodule EsprezzoCore.PeerNet.Client do
  require Logger
  require IEx
  alias EsprezzoCore.PeerNet.PeerTracker

  @doc"""
  EsprezzoCore.PeerNet.Client.connect("127.0.0.1", 30343)
  """
  def connect(address, port, node_uuid) do
    [a,b,c,d] = String.split(address, ".")
      |> Enum.map(fn x -> 
          {n, _} = Integer.parse(x)
          n
        end )

    tcp_options = [:binary, {:packet, 4}, active: true, reuseaddr: true]
    case :gen_tcp.connect({a, b, c, d}, port, tcp_options) do
      {:ok, socket} ->  
        {:ok, pid} = PeerTracker.add_peer(socket, :gen_tcp, node_uuid)
        :gen_tcp.controlling_process(socket, pid)
        {:ok, pid}
      {:error, reason} ->
        Logger.error( fn ->
          "Could not connect to remote host"
        end)
        {:error, reason}
    end
  end

  def connect_to_bootstrap_nodes(node_uuid) do
    bootstrap_nodes()
      |> Enum.map(fn x ->
        [ip, port] = String.split(x, ":")
        {port, _} = Integer.parse(port)
        __MODULE__.connect(ip, port, node_uuid)
    end)
  end

  def bootstrap_nodes do
    ["40.65.113.90:30343","52.169.4.140:30343"]
  end

end
defmodule EsprezzoCore.PeerNet.Peer do
  use GenServer, restart: :temporary
  use EsprezzoCore.PeerNet.Macros

  require Logger
  require IEx

  alias EsprezzoCore.PeerNet.WireProtocol.MessageHandlers

  def start_link(_, config) do
    GenServer.start_link(__MODULE__, config)
  end

  @doc"""
  Setup state Map. Possibly change to Struct
  """
  def init(socket: socket, transport: transport) do
    {:ok, {{a,b,c,d}, port}} = __MODULE__.ip_for_process(socket)
    state = %{}
      |> Map.put(:remote_addr, "#{a}.#{b}.#{c}.#{d}")
      |> Map.put(:remote_port, port)
      |> Map.put(:socket, socket)
      |> Map.put(:transport, transport)
    {:ok, state}
  end

  @doc"""
  EsprezzoCore.PeerNet.Peer.send_message(pid, message)
  """
  def send_message(pid, message) do
    GenServer.call(pid, {:send_message, message})
  end

  @doc"""
  p = EsprezzoCore.PeerNet.peers |> List.last
  a = EsprezzoCore.PeerNet.Peer.peer_state(p)
  """
  def peer_state(pid) do
    GenServer.call(pid, :get_state, :infinity)
  end

  # Server
  @doc"""
  SEND network message to remote connection
  """
  def handle_call({:send_message, message}, _, %{socket: socket, transport: transport} = state) do
    Logger.warn(fn ->
      "Sending message #{inspect(message)} to #{inspect(socket)}"
    end)
    message = Poison.encode!(message)

    :ok = transport.send(socket, message)
    {:reply, :ok, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @doc"""
  RECV network message from remote connection
  """
  def handle_info({:tcp, _, message}, %{socket: socket, transport: transport} = state) do
    Logger.warn(fn ->
      "handle_info // Received message #{inspect(message)} from #{inspect(socket)}"
    end)
    case MessageHandlers.process(message, socket, transport) do
      :ok ->
        {:noreply, state}
      command_message ->
        network_message = Poison.encode!(command_message)
        :ok = transport.send(socket, network_message)
        {:noreply, state}
    end
  end

  def handle_info({:tcp_closed, _}, state) do
    {:stop, :normal, state}
  end

  def handle_info({:tcp_error, reason}, %{socket: socket} = state) do
    Logger.warn(fn ->
      "TCP Error: #{inspect(reason)}. socket=#{inspect(socket)}"
    end)

    {:stop, :normal, state}
  end

  def handle_info(:timeout, state) do
    {:stop, :normal, state}
  end

 
end
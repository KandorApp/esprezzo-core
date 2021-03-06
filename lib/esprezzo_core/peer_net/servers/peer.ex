defmodule EsprezzoCore.PeerNet.Peer do
  use GenServer, restart: :temporary
  use EsprezzoCore.PeerNet.Macros
  alias EsprezzoCore.PeerNet.WireProtocol.Commands
  require Logger
  require IEx

  
  alias EsprezzoCore.PeerNet.WireProtocol.MessageHandlers

  """
  So this is a little weird
  should I send status from each independent peer
  -or-
  schedule a group send in the manager server
  right now it's sending status from the manager
  should it send a ping and reconnect?
  we can't really wait for a ping as they r async
  right now sockets are maintaining connections perfectly
  but let's see what happens when we have spotty/intermittent network connectivity
  """
  def start_link(_, config) do
    GenServer.start_link(__MODULE__, config)
  end

  @doc"""
  Setup state Map. Possibly change to Struct
  """
  def init(socket: socket, transport: transport, node_uuid: node_uuid) do
    
    {:ok, {{a,b,c,d}, port}} = __MODULE__.ip_for_process(socket)
    
    state = %{}
      |> Map.put(:remote_addr, "#{a}.#{b}.#{c}.#{d}")
      |> Map.put(:remote_port, port)
      |> Map.put(:socket, socket)
      |> Map.put(:transport, transport)
      |> Map.put(:node_uuid, node_uuid)
      |> Map.put(:pid, self())

      schedule_hello()
      #schedule_status_notification(state.remote_addr)
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
  def handle_info({:tcp, _, message}, %{socket: socket, transport: transport, remote_addr: remote_addr} = state) do
    # Logger.warn(fn ->
    #   "handle_info // Received message #{inspect(message)} from #{inspect(socket)}"
    # end)
    case MessageHandlers.process(message, socket, transport, remote_addr) do
      :noreply ->
        {:noreply, state}
      {:error, _} ->
          {:noreply, state} 
      {:ok, command_message} ->
        network_message = Poison.encode!(command_message)
        inspect(command_message)
        :ok = transport.send(socket, network_message)
        {:noreply, state}
    end
  end

  def handle_info({:tcp_closed, _}, state) do
    {:stop, :normal, state}
  end

  def handle_info({:error, _}, state) do
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
  
  @doc"""
  Periodically refresh peerlist by querying remotes
  remote should return current active peers only
  every host should be pinging each other consistently
  if one misses three consecutive responses remove it from
  the list by calling the timeout process message or returning {:stop, :normal, state}
  """
  def handle_info(:refresh_node, %{socket: socket, transport: transport, remote_addr: remote_addr} = state) do
    Logger.warn(fn ->
      "refreshing_node... #{remote_addr}"
    end)
    command_message = Commands.build("PING")
    network_message = Poison.encode!(command_message)
    :ok = transport.send(socket, network_message)
    schedule_refresh()
    {:noreply, state}
  end

  def handle_info(:send_hello, %{socket: socket, transport: transport, remote_addr: remote_addr} = state) do
    Logger.warn(fn ->
      "sending_HELLO to #{remote_addr}"
    end)
    command_message = Commands.build("HELLO")
    network_message = Poison.encode!(command_message)
    :ok = transport.send(socket, network_message)
    {:noreply, state}
  end


  def send_status(pid) do
    Process.send_after(pid, :send_status, 300)
  end
  def handle_info(:send_status, %{socket: socket, transport: transport, remote_addr: remote_addr} = state) do
    Logger.warn(fn ->
      "sending STATUS to #{remote_addr} and rescheduling"
    end)
    command_message = Commands.build("STATUS")
    network_message = Poison.encode!(command_message)
    :ok = transport.send(socket, network_message)
    schedule_status_notification(remote_addr)
    {:noreply, state}
  end


  @doc """
    EsprezzoCore.PeerNet.Peer.push_block(block)
  """
  def push_block(pid, block) do
    block = sanitize(block)
    Process.send_after(pid, {:push_block, block}, 300)
  end
  def handle_info({:push_block, block}, %{socket: socket, transport: transport, remote_addr: remote_addr} = state) do
    Logger.warn(fn ->
      "PUSHING NEW BLOCK to #{remote_addr}"
    end)
    command_message = Commands.build("NEW_BLOCK", block)
    network_message = Poison.encode!(command_message)
    Logger.info network_message
    :ok = transport.send(socket, network_message)
    {:noreply, state}
  end

  defp schedule_refresh() do
    Process.send_after(self(), :refresh_node, 33333)
  end

  defp schedule_hello() do
    Process.send_after(self(), :send_hello, 1000)
  end

  defp schedule_status_notification(remote_addr) do
    Process.send_after(self(), :send_status, 10000)
  end

  defp sanitize(map) do
    Map.drop(map, [:__meta__, :__struct__])
  end
end
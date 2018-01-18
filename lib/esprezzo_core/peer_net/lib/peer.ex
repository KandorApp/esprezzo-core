defmodule EsprezzoCore.PeerNet.Peer do
  use GenServer, restart: :temporary

  require Logger
  require IEx
  # Client

  def start_link(_, config) do
    GenServer.start_link(__MODULE__, config)
  end

  def init(socket: socket, transport: transport) do
    {:ok, %{socket: socket, transport: transport}}
  end

  def send_message(pid, message) do
    GenServer.call(pid, {:send_message, message})
  end

  # Server
  @doc"""
  SEND network message to remote connection
  """
  def handle_call({:send_message, message}, _, %{socket: socket, transport: transport} = state) do
    Logger.warn(fn ->
      "Sending message #{inspect(message)} to #{inspect(socket)}"
    end)
    :ok = transport.send(socket, message)
    {:reply, :ok, state}
  end

  @doc"""
  RECV network message from remote connection
  """
  def handle_info({:tcp, _, message}, %{socket: socket, transport: transport} = state) do
    Logger.warn(fn ->
      "Received message #{inspect(message)} from #{inspect(socket)} // Control goes here"
    end)
    # case message do
    #   "PING" ->
    #     Logger.warn(fn ->
    #       "Received PING // Sending PONG}."
    #     end)
    #     IEx.pry
    #     transport.send(socket, "PONG")
    #   message ->
    #     Logger.warn(fn ->
    #       "Received message #{inspect(message)} from #{inspect(socket)}."
    #     end)
    # end
    Logger.warn(fn ->
      "Received message #{inspect(message)} from #{inspect(socket)}."
    end)
    transport.send(socket, message)
    IEx.pry
    {:noreply, state}
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
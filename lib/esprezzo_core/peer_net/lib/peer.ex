defmodule EsprezzoCore.PeerNet.Peer do
  use GenServer, restart: :temporary

  require Logger

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

  def handle_call({:send_message, message}, _, %{socket: socket, transport: transport} = state) do
    Logger.debug(fn ->
      "Sending message #{inspect(message)} to #{inspect(socket)}"
    end)

    :ok = transport.send(socket, message)

    {:reply, :ok, state}
  end

  def handle_info({:tcp, _, message}, %{socket: socket, transport: transport} = state) do
    Logger.debug(fn ->
      "Received message #{inspect(message)} from #{inspect(socket)}. Echoing it back // Control goes here"
    end)
    transport.send(socket, message)
    {:noreply, state}
  end

  def handle_info({:tcp_closed, _}, state) do
    {:stop, :normal, state}
  end

  def handle_info({:tcp_error, reason}, %{socket: socket} = state) do
    Logger.debug(fn ->
      "TCP Error: #{inspect(reason)}. socket=#{inspect(socket)}"
    end)

    {:stop, :normal, state}
  end

  def handle_info(:timeout, state) do
    {:stop, :normal, state}
  end
end
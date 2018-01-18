defmodule EsprezzoCore.PeerNet.TCPHandler do
  require Logger
  alias EsprezzoCore.PeerNet.StateTracker

  def start_link(ref, socket, transport, opts) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    {:ok, pid}
  end
         
  def init(ref, socket, transport, _Opts = []) do
    :ok = :ranch.accept_ack(ref)
    :ok = transport.setopts(socket, [{:active, true}])
    {:ok, pid} = StateTracker.add_peer(socket, transport)
    :ranch_tcp.controlling_process(socket, pid)
    #loop(socket, transport)
  end

  def loop(socket, transport) do
    case transport.recv(socket, 0, 5000) do
      {:ok, data} ->
        Logger.info "Network Data Received"
        transport.send(socket, data)
        loop(socket, transport)
      _ ->
        :ok = transport.close(socket)
    end
  end

  # def loop(socket, transport) do
  #   case transport.recv(socket, 12, 5000) do
  #     {:ok, id_sz_bin} ->
  #       << id :: binary-size(8), sz :: size(32) >> = id_sz_bin
  #       case transport.recv(socket, sz, 5000) do
  #         {:ok, _ } -> # data
  #           transport.send(socket, id)
  #           loop(socket, transport)
  #         {:error, :closed} ->
  #           :ok = transport.close(socket)
  #         {:error, :timeout} ->
  #           :ok = transport.close(socket)
  #         {:error, _} -> # err_message
  #           :ok = transport.close(socket)
  #         _ ->
  #           :ok = transport.close(socket)
  #       end
  #     _ ->
  #       :ok = transport.close(socket)          
  #   end

  # end

  # def loop(socket, transport, container, timer_pid) do
  #   case transport.recv(socket, 12, 5000) do
  #     {:ok, id_sz_bin} ->
  #       << id :: binary-size(8), sz :: little-size(32) >> = id_sz_bin
  #       case transport.recv(socket, sz, 5000) do
  #         {:ok, data} ->
  #           ThrottlePerf.Container.push(container, id, data)
  #           loop(socket, transport, container, timer_pid)
  #         {:error, :timeout} ->
  #           flush(socket, transport, container)
  #           shutdown(socket, transport, container, timer_pid)
  #         _ ->
  #           shutdown(socket, transport, container, timer_pid)
  #       end
  #     _ ->
  #       shutdown(socket, transport, container, timer_pid)
  #   end
  # end
end
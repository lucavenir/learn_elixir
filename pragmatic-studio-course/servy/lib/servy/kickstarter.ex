defmodule Servy.Kickstarter do
  use GenServer

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_server() do
    GenServer.call(__MODULE__, :pid)
  end

  @impl true
  def init(:ok) do
    Process.flag(:trap_exit, true)
    pid = start_server()
    {:ok, pid}
  end

  @impl true
  def handle_call(:pid, _from, pid) do
    {:reply, pid, pid}
  end

  @impl true
  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts("HttpServer exited with reason: #{inspect(reason)}")
    pid = start_server()
    {:noreply, pid}
  end

  defp start_server() do
    port = Application.get_env(:servy, :port)
    Kernel.spawn_link(Servy.HttpServer, :start, [port])
  end
end

defmodule Servy.PledgeServer do
  use GenServer

  defmodule State do
    defstruct cache_size: 3, cache: [], pledges: []
  end

  # client interface
  def create_pledge(name, amount) do
    GenServer.call(__MODULE__, {:create, name, amount})
  end

  def recent_pledges() do
    GenServer.call(__MODULE__, :read)
  end

  def total_pledged() do
    GenServer.call(__MODULE__, :total)
  end

  def clear() do
    GenServer.cast(__MODULE__, :clear)
  end

  def set_state_cache_size(size) when is_integer(size) and size > 0 do
    GenServer.cast(__MODULE__, {:set_cache_size, size})
  end

  # helper functions

  def start(initial_state \\ []) do
    IO.puts("Starting the pledge server...")
    GenServer.start(__MODULE__, %State{}, name: __MODULE__)
  end

  # server callbacks

  @impl true
  def init(%State{} = state) do
    from_service = fetch_pledges_from_service()
    cache = update_cache(from_service)
    {:ok, %State{state | pledges: from_service, cache: cache}}
  end

  defp fetch_pledges_from_service() do
    [{"pledge-1", 100}, {"pledge-2", 200}, {"pledge-3", 300}]
  end

  @impl true
  def handle_cast(:clear, state) do
    {:noreply, %State{state | pledges: [], cache: []}}
  end

  @impl true
  def handle_cast({:set_cache_size, size}, %State{} = state) do
    resized = %State{state | cache_size: size}
    new_state = update_cache(state)
    {:noreply, new_state}
  end

  @impl true
  def handle_call(:total, _from, %State{} = state) do
    total = Enum.sum_by(state.pledges, fn {_name, amount} -> amount end)
    {:reply, total, state}
  end

  @impl true
  def handle_call(:read, _from, %State{} = state) do
    {:reply, state.cache, state}
  end

  @impl true
  def handle_call({:create, name, amount}, _from, %State{} = state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    added = %State{state | pledges: [{name, amount} | state.pledges]}
    new_state = update_cache(added)
    {:reply, id, new_state}
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  @impl true
  def handle_info(message, state) do
    IO.puts("Can't accept info atm. Received: #{inspect(message)}")
    {:noreply, state}
  end

  defp update_cache(%State{pledges: pledges, cache_size: cache_size} = state) do
    cache = Enum.take(pledges, cache_size - 1)
    %State{state | cache: cache}
  end
end

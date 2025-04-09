defmodule Servy.SensorServer do
  use GenServer

  defmodule State do
    @default_refresh_interval :timer.seconds(5)
    defstruct snapshots: [],
              location: %{lat: nil, lng: nil},
              refresh_interval: @default_refresh_interval,
              ref: nil
  end

  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def get_sensor_data() do
    GenServer.call(__MODULE__, :get)
  end

  def set_refresh_interval(time) when is_integer(time) do
    GenServer.cast(__MODULE__, {:set_refresh_interval, time})
  end

  @impl true
  def init(_) do
    initial_state = refresh()
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:get, _from, %State{} = state) do
    {:reply, state.data, state}
  end

  @impl true
  def handle_call({:set_refresh_interval, time}, _from, %State{ref: ref} = state)
      when is_integer(time) do
    Process.cancel_timer(ref)
    ref = Process.send_after(self(), :refresh, time)
    new_state = %State{state | refresh_interval: time, ref: ref}
    {:reply, :ok, new_state}
  end

  @impl true
  def handle_info(:refresh, _state) do
    new_state = refresh()
    {:noreply, new_state}
  end

  @impl true
  def handle_info(unexpected, state) do
    IO.puts("Unexpected message: #{inspect(unexpected)}")
    {:noreply, state}
  end

  defp refresh(%State{refresh_interval: refresh_interval}) do
    ref = Process.send_after(self(), :refresh, refresh_interval)
    {snapshots, location} = fetch_sensor_data()

    %State{
      snapshots: snapshots,
      location: location,
      refresh_interval: refresh_interval,
      ref: ref
    }
  end

  defp fetch_sensor_data() do
    bigfoot_task = Task.async(Servy.Tracker, :get_location, ["bigfoot"])

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(Servy.VideoCam, :get_snapshot, [&1]))
      |> Enum.map(&Task.await/1)

    where_is_bigfoot = Task.await(bigfoot_task)

    %{snapshots, where_is_bigfoot}
  end
end

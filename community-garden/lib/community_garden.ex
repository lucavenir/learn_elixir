# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  @enforce_keys [:plots, :counter]
  defstruct [:plots, :counter]
  def start(opts \\ []), do: Agent.start(fn -> %CommunityGarden{plots: [], counter: 0} end, opts)
  def list_registrations(pid), do: Agent.get(pid, & &1.plots)
  def register(pid, register_to), do: Agent.get_and_update(pid, &append_person(register_to, &1))
  def release(pid, plot_id), do: Agent.update(pid, &remove_plot(plot_id, &1))
  def get_registration(pid, plot_id), do: Agent.get(pid, &do_get_registration(plot_id, &1.plots))

  defp append_person(person, state) do
    plot = %Plot{plot_id: state.counter + 1, registered_to: person}

    {plot,
     %CommunityGarden{
       state
       | counter: state.counter + 1,
         plots: [plot | state.plots]
     }}
  end

  defp remove_plot(plot_id, state) do
    %CommunityGarden{
      state
      | plots: Enum.reject(state.plots, fn plot -> plot.plot_id == plot_id end)
    }
  end

  defp do_get_registration(id, plots) do
    case Enum.find(plots, &(&1.plot_id == id)) do
      nil -> {:not_found, "plot is unregistered"}
      value -> value
    end
  end
end

defmodule Lasagna do
  @spec expected_minutes_in_oven() :: integer()
  def expected_minutes_in_oven, do: 40

  @spec remaining_minutes_in_oven(integer()) :: integer()
  def remaining_minutes_in_oven(elapsed), do: expected_minutes_in_oven() - elapsed

  @spec preparation_time_in_minutes(integer()) :: integer()
  def preparation_time_in_minutes(layers), do: 2 * layers

  @spec total_time_in_minutes(integer(), integer()) :: integer()
  def total_time_in_minutes(layers, elapsed) do
    preparation_time_in_minutes(layers) + elapsed
  end

  def alarm, do: "Ding!"
end

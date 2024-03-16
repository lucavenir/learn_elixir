defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(0), do: raise(ArgumentError, "count must be a positive integer")

  def nth(count) do
    Stream.iterate(2, &(&1 + 1))
    |> Stream.reject(&divisors?/1)
    |> Stream.take(count)
    |> Enum.at(-1)
  end

  defp divisors?(n) do
    2..n
    |> Stream.take_while(&(&1 * &1 - 1 < n))
    |> Enum.any?(&(rem(n, &1) == 0))
  end
end

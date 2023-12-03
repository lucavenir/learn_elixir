# using recursion
defmodule IterateMe do
  def print_n_times(msg, n) when n > 0 do
    IO.puts(msg)
    print_n_times(msg, n - 1)
  end

  def print_n_times(_msg, 0) do
    :ok
  end
end

defmodule Reduce do
  def sum([head | tail], acc) do
    sum(tail, head + acc)
  end

  def sum([], acc) do
    acc
  end
end

defmodule Map do
  def double([head | tail]) do
    [head * 2, double(tail)]
  end

  def double([]) do
    []
  end
end

# using built-ins
Enum.reduce([1, 2, 3, 4], 0, &+/2)
Enum.map([1, 2, 3, 4], &(&1 * 2))

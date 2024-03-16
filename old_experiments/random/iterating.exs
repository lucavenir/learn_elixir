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

defmodule MyReduce do
  def sum([head | tail], acc) do
    sum(tail, head + acc)
  end

  def sum([], acc) do
    acc
  end
end

defmodule MyMap do
  def double([head | tail]) do
    [head * 2, double(tail)]
  end

  def double([]) do
    []
  end
end

# using built-ins
# 1..3 |> Enum.map(&IO.puts(&1))
1..4 |> Enum.reduce(0, &+/2)
1..4 |> Enum.map(&(&1 * 2))

# more enums
%{1 => 1, 2 => 2, 3 => 3, 4 => 4} |> Enum.map(fn {k, v} -> k * v end)

# be lazy
1..4 |> Stream.map(&(&1 * 3)) |> Stream.map(&(&1 ** 2)) |> Enum.reduce(0, &+/2)

stream = Stream.unfold("hełło", &String.next_codepoint/1)
Enum.take(stream, 91)

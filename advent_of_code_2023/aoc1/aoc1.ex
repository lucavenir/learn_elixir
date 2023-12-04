defmodule GetIntegers do
  def retrieve_number(line) do
    numbers =
      line
      |> String.graphemes()
      |> Stream.filter(&String.match?(&1, ~r/^[[:digit:]]+$/))
      |> Enum.reduce("", &(&2 <> &1))

    first = String.first(numbers)
    last = String.last(numbers)
    two_digits = first <> last

    {result, _} = Integer.parse(two_digits)
    result
  end
end

result =
  File.stream!("aoc1.txt") |> Enum.map(&GetIntegers.retrieve_number(&1)) |> Enum.reduce(0, &+/2)

IO.puts(result)

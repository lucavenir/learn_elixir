defmodule DayOne do
  def retrieve_number(line) do
    line |> String.trim() |> to_number()
  end

  def to_number(line) do
    # this reverse trick is SO KOOL
    10 * first(line) + last(String.reverse(line))
  end

  for digit <- 1..9 do
    string_digit = digit |> Integer.to_string()
    defp first(<<unquote(string_digit), _::binary>>), do: unquote(digit)
    defp last(<<unquote(string_digit), _::binary>>), do: unquote(digit)
  end

  defp first(<<_::utf8, rest::binary>>), do: first(rest)
  defp last(<<_::utf8, rest::binary>>), do: last(rest)
end

result_one =
  File.stream!("aoc1.txt") |> Enum.map(&DayOne.retrieve_number/1) |> Enum.sum()

IO.puts(result_one)

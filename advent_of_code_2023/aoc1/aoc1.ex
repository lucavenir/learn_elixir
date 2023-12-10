defmodule DayOne do
  @digits %{
    "zero" => 0,
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9
  }

  def retrieve_number(line) do
    line |> String.trim() |> to_number()
  end

  def to_number(line) do
    # this reverse trick is SO KOOL
    10 * first_simple(line) + last_simple(String.reverse(line))
  end

  for digit <- 1..9 do
    string_digit = digit |> Integer.to_string()
    defp first_simple(<<unquote(string_digit), _::binary>>), do: unquote(digit)
    defp last_simple(<<unquote(string_digit), _::binary>>), do: unquote(digit)
  end

  defp first_simple(<<_::utf8, rest::binary>>), do: first_simple(rest)
  defp last_simple(<<_::utf8, rest::binary>>), do: last_simple(rest)

  def retrieve_number_but_fancy(line) do
    line |> String.trim() |> to_number_buy_fancy()
  end

  def to_number_buy_fancy(line) do
    10 * first(line) + last(String.reverse(line))
  end

  # simply matches a digit (1..9) just like above
  for digit <- 1..9 do
    string_digit = digit |> Integer.to_string()
    defp first(<<unquote(string_digit), _::binary>>), do: unquote(digit)
    defp last(<<unquote(string_digit), _::binary>>), do: unquote(digit)
  end

  # matches a spelled digit as defined in @digits
  # it then converts them into numbers as above
  for {string_digit, digit} <- @digits do
    reverse_string_digit = string_digit |> String.reverse()
    defp first(<<unquote(string_digit), _::binary>>), do: unquote(digit)
    defp last(<<unquote(reverse_string_digit), _::binary>>), do: unquote(digit)
  end

  # eats one grapheme and keeps iterating on
  defp first(<<_::utf8, rest::binary>>), do: first(rest)
  defp last(<<_::utf8, rest::binary>>), do: last(rest)
end

result_one =
  File.stream!("aoc1.txt") |> Stream.map(&DayOne.retrieve_number/1) |> Enum.sum()

result_two =
  File.stream!("aoc1.txt") |> Stream.map(&DayOne.retrieve_number_but_fancy/1) |> Enum.sum()

IO.puts(result_one)
IO.puts(result_two)

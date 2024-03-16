defmodule LucasNumbers do
  @moduledoc """
  Lucas numbers are an infinite sequence of numbers which build progressively
  which hold a strong correlation to the golden ratio (φ or ϕ)

  E.g.: 2, 1, 3, 4, 7, 11, 18, 29, ...
  """

  def generate(input) when is_integer(input) and input > 0 do
    {2, 1} |> Stream.unfold(fn {a, b} -> {a, {b, a + b}} end) |> Enum.take(input)
  end

  def generate(_), do: raise(ArgumentError, "count must be specified as an integer >= 1")
end

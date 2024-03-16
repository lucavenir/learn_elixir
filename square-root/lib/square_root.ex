defmodule SquareRoot do
  import Bitwise

  @doc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(n) when n < 2, do: n

  def calculate(number) do
    computation = 2 * calculate(number >>> 2)
    squared = (computation + 1) * (computation + 1)

    if squared > number, do: computation, else: computation + 1
  end
end

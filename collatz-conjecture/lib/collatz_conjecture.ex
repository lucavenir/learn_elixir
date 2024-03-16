defmodule CollatzConjecture do
  import Bitwise

  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(1), do: 0
  def calc(input) when is_number(input) and input > 0, do: computation(input)

  defp computation(input) when (input &&& input - 1) == 0, do: :math.log2(input)
  defp computation(input) when rem(input, 2) == 0, do: 1 + calc(Kernel.div(input, 2))
  defp computation(input), do: 1 + calc(3 * input + 1)
end

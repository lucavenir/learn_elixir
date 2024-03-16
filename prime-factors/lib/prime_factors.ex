defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number), do: do_factors_for(number, 2, []) |> Enum.reverse()

  defp do_factors_for(1, _, _), do: []

  defp do_factors_for(number, divisor, acc) do
    reminder = Kernel.rem(number, divisor)
    bound? = number > divisor * divisor - 1

    case {bound?, reminder} do
      {true, 0} -> do_factors_for(Kernel.div(number, divisor), 2, [divisor | acc])
      {true, _} -> do_factors_for(number, divisor + 1, acc)
      {false, _} -> [number | acc]
    end
  end
end

defmodule Raindrops do
  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    case {pling?(number), plang?(number), plong?(number)} do
      {true, true, true} -> "PlingPlangPlong"
      {true, true, false} -> "PlingPlang"
      {true, false, true} -> "PlingPlong"
      {false, true, true} -> "PlangPlong"
      {true, false, false} -> "Pling"
      {false, true, false} -> "Plang"
      {false, false, true} -> "Plong"
      {false, false, false} -> "#{number}"
    end
  end

  defp pling?(number), do: rem(number, 3) == 0
  defp plang?(number), do: rem(number, 5) == 0
  defp plong?(number), do: rem(number, 7) == 0
end

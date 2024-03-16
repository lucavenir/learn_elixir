defmodule PopCount do
  @doc """
  Given the number, count the number of eggs.
  """
  @spec egg_count(number :: integer()) :: non_neg_integer()
  def egg_count(number) do
    number |> Integer.digits(2) |> Enum.filter(&(&1 == 1)) |> Enum.sum()
  end
end

defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(n) when not is_number(n) or n <= 0,
    do: {:error, "Classification is only possible for natural numbers."}

  def classify(n) do
    case aliquot_sum(n) do
      sum when sum == n -> {:ok, :perfect}
      sum when sum > n -> {:ok, :abundant}
      sum when sum < n -> {:ok, :deficient}
    end
  end

  defp aliquot_sum(1), do: 0

  defp aliquot_sum(n) do
    1..div(n, 2)
    |> Enum.filter(fn x -> rem(n, x) == 0 end)
    |> Enum.sum()
  end
end

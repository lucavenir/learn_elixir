defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance(~c"AAGTCATA", ~c"TAGCGATC")
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2) when length(strand1) !== length(strand2) do
    {:error, "strands must be of equal length"}
  end

  def hamming_distance(strand1, strand2) when length(strand1) === length(strand2) do
    {:ok, compute_hamming(strand1, strand2)}
  end

  defp compute_hamming(strand1, strand2) do
    Stream.zip(strand1, strand2) |> Enum.count(fn {a, b} -> a != b end)
  end
end

defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    candidates |> Enum.filter(&anagram?(String.downcase(base), String.downcase(&1)))
  end

  defp anagram?(base, base), do: false
  defp anagram?(base, candidate), do: get_codepoints(base) === get_codepoints(candidate)

  defp get_codepoints(input) do
    input |> String.codepoints() |> Enum.sort() |> Enum.join()
  end
end

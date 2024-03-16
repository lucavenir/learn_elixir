defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  @spec compare([any()], [any()]) :: :equal | :unequal | :sublist | :superlist
  def compare(a, b) when is_list(a) and is_list(b) do
    cond do
      a === b -> :equal
      a |> subset_of?(b) -> :sublist
      b |> subset_of?(a) -> :superlist
      true -> :unequal
    end
  end

  defp subset_of?([], _), do: true

  defp subset_of?(a, b) do
    Stream.chunk_every(b, Kernel.length(a), 1, :discard) |> Enum.any?(&(&1 === a))
  end
end

defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search([], _), do: :not_found
  def search(numbers, key), do: indexed_search(numbers, key, 0, Kernel.tuple_size(numbers) - 1)

  defp indexed_search(_, _, start_index, end_index) when start_index > end_index, do: :not_found

  defp indexed_search(numbers, key, start_index, end_index) do
    middle = Kernel.div(start_index + end_index, 2)

    case Kernel.elem(numbers, middle) do
      ^key -> {:ok, middle}
      element when element > key -> indexed_search(numbers, key, 0, middle - 1)
      element when element < key -> indexed_search(numbers, key, middle + 1, end_index)
    end
  end
end

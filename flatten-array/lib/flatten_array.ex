defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten([]), do: []
  def flatten(nil), do: []
  def flatten(number) when not is_list(number), do: [number]
  def flatten([head | others]), do: flatten(head) ++ flatten(others)
end

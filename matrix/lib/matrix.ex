defmodule Matrix do
  @enforce_keys [:rows, :columns]
  defstruct [:rows, :columns]

  def from_string(input) do
    rows =
      for row <- String.split(input, "\n") do
        for value <- String.split(row, " "), do: String.to_integer(value)
      end

    %Matrix{
      rows: rows |> List.to_tuple(),
      columns: rows |> Enum.zip_with(& &1) |> List.to_tuple()
    }
  end

  def to_string(%{rows: rows}),
    do: rows |> Tuple.to_list() |> Enum.map_join("\n", &Enum.join(&1, " "))

  def rows(%{rows: rows}), do: rows |> Tuple.to_list()
  def columns(%{columns: columns}), do: columns |> Tuple.to_list()
  def row(%{rows: rows}, index), do: rows |> Kernel.elem(index - 1)
  def column(%{columns: columns}, index), do: columns |> Kernel.elem(index - 1)
end

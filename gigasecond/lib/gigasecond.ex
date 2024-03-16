defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          {{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}
  def from({{_year, _month, _day}, {_hours, _minutes, _seconds}} = erlang_tuple) do
    NaiveDateTime.from_erl!(erlang_tuple)
    |> NaiveDateTime.add(1_000_000_000, :second)
    |> NaiveDateTime.to_erl()
  end
end

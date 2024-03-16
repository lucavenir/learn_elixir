defmodule KitchenCalculator do
  def convert(tuple, unit), do: tuple |> to_milliliter() |> from_milliliter(unit)

  def to_milliliter({atom, number}) do
    factor = atom |> get_to_milli_factor()
    {:milliliter, number * factor}
  end

  def from_milliliter({_, number}, unit) do
    factor = unit |> get_to_milli_factor()
    {unit, number / factor}
  end

  defp get_to_milli_factor(:cup), do: 240
  defp get_to_milli_factor(:fluid_ounce), do: 30
  defp get_to_milli_factor(:tablespoon), do: 15
  defp get_to_milli_factor(:teaspoon), do: 5
  defp get_to_milli_factor(:milliliter), do: 1

  def get_volume({_, number}), do: number
end

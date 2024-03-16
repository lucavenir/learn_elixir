defmodule BoutiqueInventory do
  def sort_by_price(inventory), do: inventory |> Enum.sort_by(& &1.price)

  def with_missing_price(inventory), do: inventory |> Enum.filter(&price_missing?/1)
  defp price_missing?(%{price: nil}), do: true
  defp price_missing?(_), do: false

  def update_names(inventory, old_word, new_word) do
    inventory |> Enum.map(&name_updater(&1, old_word, new_word))
  end

  defp name_updater(%{name: name, price: p, quantity_by_size: q}, old_name, new_name) do
    %{name: String.replace(name, old_name, new_name), price: p, quantity_by_size: q}
  end

  def increase_quantity(%{name: name, price: price, quantity_by_size: sizes}, count) do
    %{name: name, price: price, quantity_by_size: increase_quantity_by_size(sizes, count)}
  end

  defp increase_quantity_by_size(sizes, count), do: sizes |> Map.new(&increase(&1, count))
  defp increase({size, amount}, count), do: {size, amount + count}

  def total_quantity(%{quantity_by_size: sizes}) do
    sizes |> Enum.reduce(0, &get_quantity/2)
  end

  defp get_quantity({_, amount}, count), do: amount + count
end

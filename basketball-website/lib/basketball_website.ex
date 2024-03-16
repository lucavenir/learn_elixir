defmodule BasketballWebsite do
  def extract_from_path(data, path), do: extract_from(data, String.split(path, "."))
  defp extract_from(nil, _), do: nil
  defp extract_from(data, []), do: data
  defp extract_from(data, [head | tail]), do: extract_from(data[head], tail)

  def get_in_path(data, path), do: Kernel.get_in(data, String.split(path, "."))
end

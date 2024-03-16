defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string), do: string |> filter_and_split() |> acronym() |> String.upcase()
  defp filter_and_split(string), do: String.split(string, ~r/[\s-_]|(?=[A-Z][a-z]+)/, trim: true)
  defp acronym(words), do: words |> Stream.map(&String.first/1) |> Enum.join()
end

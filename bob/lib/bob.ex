defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    cond do
      silence?(input) -> "Fine. Be that way!"
      question?(input) and yelling?(input) -> "Calm down, I know what I'm doing!"
      question?(input) -> "Sure."
      yelling?(input) -> "Whoa, chill out!"
      true -> "Whatever."
    end
  end

  defp silence?(input), do: input |> String.match?(~r/^[\s]*$/)
  defp question?(input), do: input |> String.trim() |> String.match?(~r/\?$/)
  defp yelling?(input), do: some_letters?(input) and String.upcase(input) == input
  defp some_letters?(input), do: String.match?(input, ~r/(?=\D)\w/)
end

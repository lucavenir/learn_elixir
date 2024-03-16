defmodule PigLatin do
  @vowels ~c"aeiou"
  @almost_vowels ~c"xy"
  @q "qu"

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase |> String.split() |> Enum.map(&translate_word/1) |> Enum.join(" ")
  end

  defp translate_word(<<first::utf8, _::bitstring>> = word) when first in @vowels, do: <<word::bitstring, "ay">>
  defp translate_word(<<first::utf8, second::utf8, _::bitstring>> = word) when first in @almost_vowels and second not in @vowels, do: <<word::bitstring, "ay">>
  defp translate_word(<<first::utf8, second::utf8, rest::bitstring>>) when <<first, second>> == @q, do: translate_word(<<rest::bitstring, first, second>>)
  defp translate_word(<<first::utf8, rest::bitstring>>), do: translate_word(<<rest::bitstring, first>>)
end

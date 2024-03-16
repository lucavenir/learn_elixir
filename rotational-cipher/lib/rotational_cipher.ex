defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """

  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    text |> String.graphemes() |> Enum.map(&<<shift_char(&1, shift)::utf8>>) |> Enum.join()
  end

  defp shift_char(<<char::utf8>>, 0), do: char
  defp shift_char(<<char::utf8>>, shift) when char in ?a..?z, do: transform(char, ?z, ?a, shift)
  defp shift_char(<<char::utf8>>, shift) when char in ?A..?Z, do: transform(char, ?Z, ?A, shift)
  defp shift_char(<<char::utf8>>, _shift), do: char

  defp transform(char, upper, lower, shift) do
    (char - lower + shift) |> Kernel.rem(upper - lower + 1) |> Kernel.+(lower)
  end
end

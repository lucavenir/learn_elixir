defmodule SecretHandshake do
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    code
    |> Integer.digits(2)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce([], &add_action/2)
    |> Enum.reverse()
  end

  defp add_action({1, 0}, list), do: ["wink" | list]
  defp add_action({1, 1}, list), do: ["double blink" | list]
  defp add_action({1, 2}, list), do: ["close your eyes" | list]
  defp add_action({1, 3}, list), do: ["jump" | list]
  defp add_action({1, 4}, list), do: Enum.reverse(list)
  defp add_action(_, list), do: list
end

defmodule ResistorColorTrio do
  @doc """
  Calculate the resistance value in ohms from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms | :megaohms | :gigaohms}
  def label([first, second, third | _]) do
    value = (10 * code(first) + code(second)) * 10 ** code(third)

    additional_zero = if second == :black, do: 1, else: 0
    zeros = code(third) + additional_zero
    compute_contracted(value, zeros)
  end

  @spec code(atom) :: integer()
  defp code(:black), do: 0
  defp code(:brown), do: 1
  defp code(:red), do: 2
  defp code(:orange), do: 3
  defp code(:yellow), do: 4
  defp code(:green), do: 5
  defp code(:blue), do: 6
  defp code(:violet), do: 7
  defp code(:grey), do: 8
  defp code(:white), do: 9

  @magnitudes %{
    0 => :ohms,
    1 => :kiloohms,
    2 => :megaohms,
    3 => :gigaohms
  }

  defp compute_contracted(actual_number, zeros) do
    tens = Kernel.div(zeros, 3)
    trimmed_tens = if tens > 3, do: 3, else: tens
    contract_factor = zeros - Kernel.rem(zeros, 3)
    {Kernel.div(actual_number, 10 ** contract_factor), @magnitudes[trimmed_tens]}
  end
end

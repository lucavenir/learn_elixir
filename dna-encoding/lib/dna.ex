defmodule DNA do
  def encode_nucleotide(?\s), do: 0b0000
  def encode_nucleotide(?A), do: 0b0001
  def encode_nucleotide(?C), do: 0b0010
  def encode_nucleotide(?G), do: 0b0100
  def encode_nucleotide(?T), do: 0b1000

  def decode_nucleotide(0b0000), do: ?\s
  def decode_nucleotide(0b0001), do: ?A
  def decode_nucleotide(0b0010), do: ?C
  def decode_nucleotide(0b0100), do: ?G
  def decode_nucleotide(0b1000), do: ?T

  def encode(dna), do: do_encode(dna, <<>>)
  defp do_encode([], acc), do: acc

  defp do_encode([head | tail], acc),
    do: do_encode(tail, <<acc::bitstring, encode_nucleotide(head)::4>>)

  def decode(dna), do: do_decode(dna, []) |> reverse()
  defp do_decode(<<>>, acc), do: acc

  defp do_decode(<<head::4, tail::bitstring>>, acc),
    do: do_decode(tail, [decode_nucleotide(head) | acc])

  defp reverse(dna), do: do_reverse(dna, [])
  defp do_reverse([], acc), do: acc
  defp do_reverse([head | tail], acc), do: do_reverse(tail, [head | acc])
end

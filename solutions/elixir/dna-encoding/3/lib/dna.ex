defmodule DNA do
  def encode_nucleotide(?A), do: 1
  def encode_nucleotide(?C), do: 2 ** 1
  def encode_nucleotide(?G), do: 2 ** 2
  def encode_nucleotide(?T), do: 2 ** 3
  def encode_nucleotide(_), do: 0


  def decode_nucleotide(1), do: ?A
  def decode_nucleotide(2), do: ?C
  def decode_nucleotide(4), do: ?G
  def decode_nucleotide(8), do: ?T
  def decode_nucleotide(_), do: ?\s

  defp do_encode([], acc), do: acc
  defp do_encode([head | tail], acc), do: do_encode(tail, <<acc::bitstring, encode_nucleotide(head)::4>>)
  def encode(dna) do
    do_encode(dna, <<>>)
  end


  # defp do_decode(<<>>, acc), do: acc |> Enum.reverse()
  # defp do_decode(<<head::4, tail::bitstring>>, acc), do: do_decode(tail, [decode_nucleotide(head) | acc])
  # """
  # The purpose of this exercise is to teach recursion. Solve it without using list comprehensions or any of the functions from the modules Enum, List, or Stream.
  # """
  defp do_decode(<<>>, acc), do: acc
  defp do_decode(<<head::4, tail::bitstring>>, acc), do: do_decode(tail, acc ++ [decode_nucleotide(head)])
  def decode(dna) do
    do_decode(dna, ~c"")
  end
end

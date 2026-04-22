defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency([], _), do: %{}
  def frequency(texts, workers) do
    texts
    |> Enum.chunk_every(div(Enum.count(texts), workers))
    |> Enum.map(&Task.async(fn -> get_text_frequency(&1) end))
    |> Task.await_many()
    |> reduce_frequencies()
  end

  @spec get_text_frequency([String.t()]) :: map
  defp get_text_frequency(texts) do
    texts
    |> Enum.map(fn text ->
      String.graphemes(text)
      |> Enum.map(&String.downcase/1)
      |> Enum.filter(&Regex.match?(~r/^\p{L}$/u, &1))
      |> Enum.frequencies()
    end)
    |> reduce_frequencies()
  end

  defp reduce_frequencies(list) do
    Enum.reduce(list, %{}, fn map, acc ->
      Map.merge(acc, map, fn _key, v1, v2 -> v1 + v2 end)
    end)
  end

end

defmodule ElixirAlgorithm.Compression.RunLength do
  @moduledoc """
  Implementation for RunLength compression algorithm.
  """

  @doc """
  Encodes a binary data.

  ## Examples

      iex> RunLength.encode("AABB")
      [{"B", 2}, {"A", 2}]
  """
  @spec encode(String.t()) :: list({String.t(), integer()})
  def encode(data) do
    do_encode(data, [])
  end

  defp do_encode("", accumulator), do: accumulator
  defp do_encode(data, accumulator) do
    char = String.first(data)
    data
    |> remove_first_char
    |> do_encode(
      check_char(char, accumulator)
    )
  end

  defp remove_first_char(data), do: String.slice(data, 1, String.length(data) - 1)

  defp check_char(char, []), do: [{char, 1}]
  defp check_char(char, [{current_char, size} | tail]) when current_char == char, do: [{char, size + 1} | tail]
  defp check_char(char, accumulator), do: [{char, 1} | accumulator]

  @doc """
  Decodes an encoded data.

  ## Examples

      iex> RunLength.decode([{"B", 2}, {"A", 2}])
      "AABB"
  """
  @spec decode(list({String.t(), integer()})) :: String.t()
  def decode(data) do
    data
    |> do_decode("")
  end

  defp do_decode([], accumulator), do: accumulator
  defp do_decode([{char, repeat} | data_tail], accumulator) do
    acc = String.duplicate(char, repeat) <> accumulator
    do_decode(data_tail, acc)
  end
end

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

  defp handle_file(path, output_name, chunk_func) do
    path
    |> File.stream!
    |> Stream.map(fn chunk -> chunk_func.(chunk) end)
    |> Stream.into(File.stream!(output_name, [:write]))
    |> Stream.run()
  end

  @doc """
  Encodes a file with the given path.

    ## Examples

        iex> RunLength.encode_file("my_file.txt")
        {:ok, "my_file.txt.rl"}

        iex> RunLength.encode_file("my_file.txt", "output.txt")
        {:ok, "output.txt.rl"}
  """
  @spec encode_file(String.t()) :: {:ok, String.t()}
  def encode_file(path), do: encode_file(path, path)
  @spec encode_file(String.t(), String.t()) :: {:ok, String.t()}
  def encode_file(path, output_name) do
    output = "#{output_name}.rl"
    handle_file(path, output, &encode_chunk/1)
    {:ok, output}
  end

  defp encode_chunk(chunk) do
    chunk
    |> encode
    |> Enum.map(fn {char, size} -> "#{size}=#{char};" end)
  end

  @doc """
  Decodes a encoded file in the given path.

    ## Examples

        iex> RunLength.decode_file("my_file.rl")
        {:ok, "my_file"}

        iex> RunLength.decode_file("my_file.rl", "output.txt")
        {:ok, "output.txt"}
  """
  def decode_file(path), do: decode_file(path, path)
  def decode_file(path, output_name) do
    handle_file(path, output_name, &decode_chunk/1)
  end

  defp decode_chunk(chunk) do
    chunk
    |> String.split(";")
    |> Enum.filter(fn chunk_split -> chunk_split != "" end)
    |> Enum.reverse()
    |> Enum.map_join(fn chunk_data ->
      [size | [char]] = String.split(chunk_data, "=")
      String.duplicate(char, String.to_integer(size))
    end)
  end
end

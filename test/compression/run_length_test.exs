defmodule ElixirAlgorithmTest.Compression.RunLength do
  @moduledoc """
  Testing for RunLength compression algorithm.
  """

  use ExUnit.Case

  alias ElixirAlgorithm.Compression.RunLength

  doctest RunLength

  describe "encode/1" do
    test "when data is provided, returns encoded data" do
      data = "AABBBBCC"
      assert RunLength.encode(data) == [{"C", 2}, {"B", 4}, {"A", 2}]
      data = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABC"
      assert RunLength.encode(data) == [{"C", 1}, {"B", 1}, {"A", 34}]
      data = "99992222"
      assert RunLength.encode(data) == [{"2", 4}, {"9", 4}]
    end
    test "when empty data is provided, returns []" do
      data = ""
      assert RunLength.encode(data) == []
    end
  end

  describe "decode/1" do
    test "when encoded data is provided, returns decoded data" do
      data = [{"B", 2}, {"A", 2}]
      assert RunLength.decode(data) == "AABB"
    end
    test "when empty data is provided, returns empty string" do
      assert RunLength.decode([]) == ""
    end
    test "decoding doesn't changes original data" do
      data = "LOREM IPSUM DOLOR"
      encoded_data = RunLength.encode(data)
      assert RunLength.decode(encoded_data) == data
    end
  end
end

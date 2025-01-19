defmodule ElixirAlgorithm.Math.Fibonnaci do
  @moduledoc """
  Implementation for Fibonnaci sequence.
  """

  def run(max) do
    do_run(0, max, [0])
  end

  def do_run(count, max, acc) when count > max, do: acc
  def do_run(count, max, acc) do
    do_run(count + 1, max, acc ++ [get_value(acc)])
  end

  defp get_value([0]), do: 1
  defp get_value(acc), do: Enum.at(acc, -2) + Enum.at(acc, -1)

end

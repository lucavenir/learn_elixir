defmodule Darts do
  @type position :: {number(), number()}

  @doc """
  Calculate the score of a single dart hitting a target
  """
  @spec score(position) :: integer()
  def score({x, y}), do: {x, y} |> distance() |> compute_score()

  defp compute_score(x) when x > 10, do: 0
  defp compute_score(x) when x > 5, do: 1
  defp compute_score(x) when x > 1, do: 5
  defp compute_score(_), do: 10

  defp distance({x, y}), do: (x ** 2 + y ** 2) ** 0.5
end

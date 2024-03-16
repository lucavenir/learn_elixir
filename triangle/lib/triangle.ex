defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) do
    are_numbers = is_number(a) and is_number(b) and is_number(c)
    are_positive = a > 0 and b > 0 and c > 0
    is_valid_triangle = a + b >= c and b + c >= a and a + c >= b

    cond do
      not are_numbers -> {:error, "all sides must be numbers"}
      not are_positive -> {:error, "all side lengths must be positive"}
      not is_valid_triangle -> {:error, "side lengths violate triangle inequality"}
      true -> {:ok, compute_kind(a, b, c)}
    end
  end

  defp compute_kind(a, a, a), do: :equilateral

  defp compute_kind(a, a, _), do: :isosceles
  defp compute_kind(a, _, a), do: :isosceles
  defp compute_kind(_, a, a), do: :isosceles

  defp compute_kind(_, _, _), do: :scalene
end

defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add(a, b)
  def add({n1, d1}, {n2, d2}), do: {n1 * d2 + n2 * d1, d1 * d2} |> reduce()

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract(a, b), do: add(a, negative(b))

  @spec negative(a :: rational) :: rational
  defp negative(a)
  defp negative({n, d}), do: {-n, d}

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply(a, b)
  def multiply({n1, d1}, {n2, d2}), do: {n1 * n2, d1 * d2} |> reduce()

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by(num, den)
  def divide_by({n1, d1}, {n2, d2}) when n2 != 0, do: {n1 * d2, n2 * d1} |> reduce()
  # what do when n2==0?

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs(a)
  def abs({n, d}), do: {Kernel.abs(n), Kernel.abs(d)} |> reduce()

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, p :: integer) :: rational
  def pow_rational(a, p)
  def pow_rational({n, d}, p) when p >= 0, do: {n ** p, d ** p} |> reduce()
  def pow_rational({n, d}, p) when p < 0, do: pow_rational({d, n}, Kernel.abs(p))

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, a :: rational) :: float
  def pow_real(x, a)
  def pow_real(x, {n, d}), do: (x ** n) |> qth_root(d)

  @spec qth_root(p :: integer, q :: integer) :: float
  defp qth_root(p, q), do: p ** (1 / q)

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce(a)

  def reduce({n, d}) do
    factor = gcd(n, d)
    {n / factor, d / factor} |> standard_form()
  end

  @spec gcd(a :: number, b :: number) :: number
  defp gcd(a, b)
  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, Kernel.rem(a, b))

  @spec standard_form(a :: rational) :: rational
  defp standard_form(a)
  defp standard_form({n, d}) when d < 0, do: {-n, -d}
  defp standard_form(a), do: a
end

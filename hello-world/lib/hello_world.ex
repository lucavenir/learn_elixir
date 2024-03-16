defmodule HelloWorld do
  @doc """
  Simply returns "Hello, World!"
  """
  @spec hello :: String.t()
  def hello, do: "Hello, World!"

  @spec add(number(), number()) :: number()
  def add(x, y), do: x + y
end

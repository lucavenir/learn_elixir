defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    def exception([]), do: %StackUnderflowError{}

    def exception(value),
      do: %StackUnderflowError{message: "stack underflow occurred, context: #{value}"}
  end

  def divide(list) when length(list) < 2, do: raise(StackUnderflowError, "when dividing")
  def divide([0, _]), do: raise(DivisionByZeroError)
  def divide([divisor, dividend]), do: dividend / divisor
end

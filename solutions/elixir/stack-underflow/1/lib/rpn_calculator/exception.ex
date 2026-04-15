defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred", context: nil

    @impl true
    def exception(context) do
      case context do
        [] -> %StackUnderflowError{}
        context -> %StackUnderflowError{context: context}
      end
    end

    def message(t) do
      t.message <> if !t.context, do: "", else: ", context: " <> t.context
    end
  end

  def divide([]), do: (raise StackUnderflowError, "when dividing")
  def divide([_]), do: (raise StackUnderflowError, "when dividing")
  def divide([0, _]), do: raise DivisionByZeroError
  def divide([divisor, dividend]), do: div(dividend, divisor)
end

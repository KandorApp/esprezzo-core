defmodule EsprezzoCore.VirtualMachine.StackMachine do  
  @doc """
  EsprezzoCore.VirtualMachine.StackMachine.execute([:push, 4, :push, 5, :push, :add_and_double, :call, :inspect, :halt, :label, :add_and_double, :add, :push, 2, :multiply, :return])
  """
  def execute(code), do: _execute(code, [])

  defp _execute([], stack), do: stack
  defp _execute([:push | [value | code]], stack) do
    _execute(code, [value | stack])
  end
  defp _execute([:add | code], [a | [b | rest_of_stack]]) do
    _execute(code, [a + b | rest_of_stack])
  end
  defp _execute([:multiply | code], [a | [b | rest_of_stack]]) do
    _execute(code, [a * b | rest_of_stack])
  end
  defp _execute([:label | [_label | code]], stack) do
    _execute(code, stack)
  end
  defp _execute([:inspect | code], stack) do
    IO.puts hd(stack)
    _execute(code, stack)
  end
  defp _execute([:call | code], [label | stack]) do
    new_stack = _execute(subroutine(code, label), stack)
    _execute(code, new_stack)
  end
  defp _execute([:return | _code], stack), do: stack
  defp _execute([:halt | _code], _stack), do: :halted

  defp subroutine([:label | [label | code]], label), do: code
  defp subroutine([_ | code], label), do: subroutine(code, label)
end  

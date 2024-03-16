defmodule TopSecret do
  def to_ast(string), do: Code.string_to_quoted!(string)

  def decode_secret_message_part({op, _, args} = ast, acc) when op in [:def, :defp] do
    {f_name, f_args} = get_function_info(args)
    arity = length(f_args)
    result = "#{f_name}" |> String.slice(0, arity)
    {ast, [result | acc]}
  end

  def decode_secret_message_part(ast, acc), do: {ast, acc}

  def decode_secret_message(string) do
    {_ast, acc} = Macro.prewalk(to_ast(string), [], &decode_secret_message_part/2)
    acc |> Enum.reverse() |> Enum.join()
  end

  defp get_function_info([{:when, _, args} | _]), do: get_function_info(args)
  defp get_function_info([{name, _, args} | _]) when is_list(args), do: {name, args}
  defp get_function_info([{name, _, args} | _]) when is_atom(args), do: {name, []}
end

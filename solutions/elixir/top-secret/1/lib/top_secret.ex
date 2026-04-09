defmodule TopSecret do
  def to_ast(string) do
    {_, quoted} = Code.string_to_quoted(string)
    quoted
  end

  def decode_secret_message_part({op, _, [{:when, _, [{name, _, args} | _]} | _]} = ast, acc) when op in [:def, :defp] do
    arity = if is_list(args), do: Enum.count(args), else: 0
    {ast, [(if arity == 0, do: "", else: name |> to_string() |> String.slice(0..(arity - 1))) | acc]}
  end

  def decode_secret_message_part({op, _, [{name, _, args} | _]} = ast, acc) when op in [:def, :defp] do
    arity = if is_list(args), do: Enum.count(args), else: 0
    {ast, [(if arity == 0, do: "", else: name |> to_string() |> String.slice(0..(arity - 1))) | acc]}
  end
  def decode_secret_message_part(ast, acc), do: {ast, acc}

  def decode_secret_message(string) do
    {_, acc} = string
    |> to_ast()
    |> Macro.prewalk([], &decode_secret_message_part/2)

    acc
    |> Enum.reverse()
    |> Enum.join()
  end
end

defmodule BasketballWebsite do
  @spec extract_from_path(nil | maybe_improper_list() | map(), binary()) :: no_return()
  def extract_from_path(data, path) do
    # First iteration:
    #   [head | tail] = path |> String.split(".")
    #   if tail, do: extract_from_path(data[head], tail |> Enum.join(".")), else: data[head]

    case String.split(path, ".") do
      [head] -> data[head]
      [head | tail] -> extract_from_path(data[head], Enum.join(tail, "."))
    end
  end

  def get_in_path(data, path) do
    get_in(data, String.split(path, "."))
  end
end

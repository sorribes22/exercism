defmodule NameBadge do
  def print(id, name, nil), do: print(id, name, "owner")
  def print(nil, name, department), do: "#{name} - #{department |> String.upcase()}"
  def print(id, name, department), do: "[#{id}] - #{name} - #{department |> String.upcase()}"
end

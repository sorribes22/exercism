defmodule LanguageList do
  def new() do
    []
  end

  def add(list, language) do
    [language | list]
  end

  def remove(list) do
    list |> List.delete_at(0)
  end

  def first(list) do
    list |> List.first
  end

  def count(list) do
    list |> length
  end

  def functional_list?(list) do
    "Elixir" in list
  end
end

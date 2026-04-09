defmodule BoutiqueInventory do
  def sort_by_price(inventory), do: inventory |> Enum.sort_by(& &1[:price], :asc)

  def with_missing_price(inventory), do: inventory |> Enum.filter(& !&1[:price])

  def update_names(inventory, old_word, new_word) do
    inventory
    |> Enum.map(fn item ->
      new_name = item[:name]
      |> String.split(" ")
      |> Enum.map(fn word -> if word == old_word, do: new_word, else: word end)
      |> Enum.join(" ")

      %{item | name: new_name}
    end)
  end

  def increase_quantity(item, count) do
    new_quantities = Map.new(item[:quantity_by_size], fn {size, quantity} -> {size, quantity + count} end)

    %{item | quantity_by_size: new_quantities}
  end

  def total_quantity(item) do
    item[:quantity_by_size]
    |> Enum.reduce(0, fn {_, quantity}, acc -> acc + quantity end)
  end
end

defmodule BoutiqueSuggestions do
  def get_combinations(tops, bottoms, options \\ [])
  def get_combinations(tops, bottoms, [maximum_price: maximum_price]) do
    for x <- tops,
        y <- bottoms, x.base_color != y.base_color and (x.price + y.price) <= maximum_price do
        {x, y}
    end
  end
  def get_combinations(tops, bottoms, _), do: get_combinations(tops, bottoms, [maximum_price: 100])
end

defmodule GottaSnatchEmAll do
  @type card :: String.t()
  @type collection :: MapSet.t(card())

  @spec new_collection(card()) :: collection()
  def new_collection(card), do: MapSet.new([card])

  @spec add_card(card(), collection()) :: {boolean(), collection()}
  def add_card(card, collection) do
    already_exists = collection |> MapSet.member?(card)

    {already_exists, MapSet.put(collection, card)}
  end

  @spec trade_card(card(), card(), collection()) :: {boolean(), collection()}
  def trade_card(your_card, their_card, collection) do
    you_have_your_card = collection |> MapSet.member?(your_card)
    you_dont_have_their_card = not MapSet.member?(collection, their_card)

    {
      you_have_your_card and you_dont_have_their_card,
      collection
      |> MapSet.delete(your_card)
      |> MapSet.put(their_card)
    }
  end

  @spec remove_duplicates([card()]) :: [card()]
  def remove_duplicates(cards), do: MapSet.new(cards) |> Enum.sort()

  @spec extra_cards(collection(), collection()) :: non_neg_integer()
  def extra_cards(your_collection, their_collection), do: MapSet.difference(your_collection, their_collection) |> MapSet.size()

  @spec boring_cards([collection()]) :: [card()]
  def boring_cards([]), do: []
  def boring_cards(collections) do
    collections
    |> Enum.reduce(fn col, acc -> MapSet.intersection(acc, col) end)
    |> MapSet.to_list()
    |> Enum.sort()
  end

  @spec total_cards([collection()]) :: non_neg_integer()
  def total_cards([]), do: 0
  def total_cards(collections) do
    collections
    |> Enum.reduce(fn col, acc -> MapSet.union(acc, col) end)
    |> MapSet.size()
  end

  @spec split_shiny_cards(collection()) :: {[card()], [card()]}
  def split_shiny_cards(collection) do
    {shiny_cards, cards} = collection |> MapSet.split_with(fn card -> card |> String.starts_with?("Shiny ") end)
    {
      shiny_cards |> MapSet.to_list() |> Enum.sort(),
      cards |> MapSet.to_list() |> Enum.sort(),
    }
  end
end

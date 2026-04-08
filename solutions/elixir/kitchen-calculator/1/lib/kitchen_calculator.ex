defmodule KitchenCalculator do
  @cup_to_milliliter 240
  @fluid_ounce_to_milliliter 30
  @teaspoon_to_milliliter 5
  @tablespoon_to_milliliter 15

  def get_volume({_unit, volume}) do
    volume
  end

  def to_milliliter({:cup, volume}) do
    {:milliliter, volume * @cup_to_milliliter}
  end

  def to_milliliter({:fluid_ounce, volume}) do
    {:milliliter, volume * @fluid_ounce_to_milliliter}
  end

  def to_milliliter({:teaspoon, volume}) do
    {:milliliter, volume * @teaspoon_to_milliliter}
  end

  def to_milliliter({:tablespoon, volume}) do
    {:milliliter, volume * @tablespoon_to_milliliter}
  end

  def to_milliliter(volume_pair) do
    volume_pair
  end

  def from_milliliter({_, volume}, unit = :cup) do
    {unit, volume / @cup_to_milliliter}
  end

  def from_milliliter({_, volume}, unit = :fluid_ounce) do
    {unit, volume / @fluid_ounce_to_milliliter}
  end

  def from_milliliter({_, volume}, unit = :teaspoon) do
    {unit, volume / @teaspoon_to_milliliter}
  end

  def from_milliliter({_, volume}, unit = :tablespoon) do
    {unit, volume / @tablespoon_to_milliliter}
  end

  def from_milliliter(volume_pair, unit) do
    volume_pair
  end

  def convert(volume_pair, unit) do
    volume_pair
    |> to_milliliter
    |> from_milliliter(unit)
  end
end

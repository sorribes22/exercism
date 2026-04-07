defmodule Lasagna do
  # Define it as module attribute
  @expected_minutes_in_oven 40
  @minutes_for_layer 2

  # - Does expected_minutes_in_oven() act as a getter? Do we really need it?
  def expected_minutes_in_oven(), do: @expected_minutes_in_oven

  # Prevents for negative numbers
  def remaining_minutes_in_oven(current_minutes) when current_minutes >= 0 do
    expected_minutes_in_oven() - current_minutes
  end

  # Returns an idiomatical error tupla if minutes are invalid
  def remaining_minutes_in_oven(_) do
    {:error, :invalid_minutes}
  end

  def preparation_time_in_minutes(num_layers), do: num_layers * @minutes_for_layer

  def total_time_in_minutes(num_layers, current_minutes) do
    preparation_time_in_minutes(num_layers) + current_minutes
  end

  def alarm(), do: "Ding!"
end

defmodule BirdCount do
  def today(list) do
    list |> List.first
  end

  def increment_day_count([]), do: [1]
  def increment_day_count([head | tail]) do
    [head + 1 | tail]
  end

  def has_day_without_birds?([]), do: false
  def has_day_without_birds?([0 | _tail]), do: true
  def has_day_without_birds?([_head | tail]), do: has_day_without_birds?(tail)

  def total(list, accum \\ 0)
  def total([], accum), do: accum
  def total([head | tail], accum), do: total(tail, head + accum)

  def busy_days(list, accum \\ 0)
  def busy_days([], accum), do: accum
  def busy_days([head | tail], accum) when head >= 5, do: busy_days(tail, accum + 1)
  def busy_days([_head | tail], accum), do: busy_days(tail, accum)
end

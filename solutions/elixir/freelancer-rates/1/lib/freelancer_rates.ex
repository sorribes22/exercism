defmodule FreelancerRates do
  @hours_per_day 8
  @days_per_month 22

  def daily_rate(hourly_rate) do
    hourly_rate * @hours_per_day * 1.0
  end

  def apply_discount(before_discount, discount) do
    before_discount * (100 - discount) / 100
  end

  def monthly_rate(hourly_rate, discount) do
    # First iteration:
    #   hourly_rate |> daily_rate * @days_per_month |> apply_discount(_, discount)

    hourly_rate
    |> daily_rate
    |> then(&(&1 * @days_per_month)) # Kernel.*(@days_per_month)
    |> apply_discount(discount)
    |> ceil
  end

  def days_in_budget(budget, hourly_rate, discount) do
    # First iteration:
    #   daily_rate_with_discount = hourly_rate |> daily_rate
    #   
    #   if discount > 0 do
    #     daily_rate_with_discount = daily_rate_with_discount |> apply_discount(discount)
    #   end
    #   
    #   budget / daily_rate_with_discount
    #   |> Float.floor(1)

    hourly_rate
    |> daily_rate
    |> apply_discount(discount)
    |> then(&(Float.floor(budget / &1, 1)))
  end
end

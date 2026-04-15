defmodule LibraryFees do
  def datetime_from_string(string) do
    {_, date} = NaiveDateTime.from_iso8601(string)
    date
  end

  def before_noon?(datetime) do
    datetime
    |> NaiveDateTime.to_time()
    |> Time.before?(~T[12:00:00])
  end

  def return_date(checkout_datetime) do
    checkout_datetime
    |> NaiveDateTime.to_date()
    |> Date.add(if before_noon?(checkout_datetime), do: 28, else: 29)
  end

  def days_late(planned_return_date, actual_return_datetime) do
    diff_in_days = actual_return_datetime
    |> NaiveDateTime.to_date()
    |> Date.diff(planned_return_date)

    if diff_in_days >= 0, do: diff_in_days, else: 0
  end

  def monday?(datetime) do
    datetime
    |> NaiveDateTime.to_date()
    |> Date.day_of_week() == 1
  end

  def calculate_late_fee(checkout, return, rate) do
    checkout_datetime = datetime_from_string(checkout)
    return_datetime = datetime_from_string(return)
    planned_return = return_date(checkout_datetime)
    days_late = days_late(planned_return, return_datetime)

    late_fee = days_late * rate
    if monday?(return_datetime), do: div(late_fee, 2), else: late_fee
  end
end

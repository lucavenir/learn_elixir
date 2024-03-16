defmodule LibraryFees do
  def datetime_from_string(string), do: NaiveDateTime.from_iso8601!(string)

  def before_noon?(datetime) do
    datetime |> NaiveDateTime.to_time() |> Time.before?(~T[12:00:00])
  end

  def return_date(checkout_datetime) do
    checkout_datetime
    |> NaiveDateTime.to_date()
    |> Date.add(if before_noon?(checkout_datetime), do: 28, else: 29)
  end

  def days_late(planned_return_date, actual_return_datetime) do
    actual_return_datetime
    |> NaiveDateTime.to_date()
    |> Date.diff(planned_return_date)
    |> Kernel.max(0)
  end

  def monday?(datetime), do: datetime |> NaiveDateTime.to_date() |> Date.day_of_week() == 1

  def calculate_late_fee(checkout, return, rate) do
    planned_return_date = checkout |> datetime_from_string() |> return_date()
    actual_return_datetime = return |> datetime_from_string()
    late_fee = days_late(planned_return_date, actual_return_datetime) * rate

    if monday?(actual_return_datetime), do: Kernel.div(late_fee, 2), else: late_fee
  end
end

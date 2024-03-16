defmodule FreelancerRates do
  @spec daily_rate(number()) :: number()
  def daily_rate(hourly_rate), do: hourly_rate * 8.0

  @spec apply_discount(number(), number()) :: number()
  def apply_discount(before_discount, discount), do: before_discount * (100.0 - discount) / 100.0

  def monthly_rate(hourly_rate, discount) do
    result = 22 * true_daily_cost(hourly_rate, discount)
    result |> Float.ceil() |> Kernel.trunc()
  end

  def days_in_budget(budget, hourly_rate, discount) do
    result = budget / true_daily_cost(hourly_rate, discount)
    result |> Float.floor(1)
  end

  defp true_daily_cost(hourly_rate, discount) do
    hourly_rate |> daily_rate() |> apply_discount(discount)
  end
end

defmodule Ledger do
  @doc """
  Format the given entries given a currency and locale
  """
  @type currency :: :usd | :eur
  @type locale :: :en_US | :nl_NL
  @type entry :: %{amount_in_cents: integer(), date: Date.t(), description: String.t()}

  @spec format_entries(currency(), locale(), list(entry())) :: String.t()
  def format_entries(currency, locale, entries) do
    compute_header(locale) <> compute_entries(currency, locale, entries)
  end

  defp compute_header(:en_US), do: "Date       | Description               | Change       \n"
  defp compute_header(:nl_NL), do: "Datum      | Omschrijving              | Verandering  \n"

  defp compute_entries(_, _, []), do: ""

  defp compute_entries(currency, locale, entries) do
    entries
    |> Enum.sort_by(&sorting_criteria/1)
    |> Enum.map(&format_entry(currency, locale, &1))
    |> Enum.join("\n")
    |> Kernel.then(&(&1 <> "\n"))
  end

  defp sorting_criteria(tuple), do: {tuple.date.day, tuple.description, tuple.amount_in_cents}

  defp format_description(description) do
    case String.length(description) > 26 do
      true -> String.slice(description, 0, 22) <> "..."
      false -> String.pad_trailing(description, 25, " ")
    end
  end

  defp format_entry(currency, locale, entry) do
    {year, month, day} = compute_date(entry.date)
    date = format_date(locale, year, month, day)
    symbol = if(currency == :eur, do: "€", else: "$")

    formatted = format_with_currency(symbol, locale, entry)
    description = format_description(entry.description)

    date <> "| " <> description <> " |" <> formatted
  end

  defp format_with_currency(symbol, locale, entry) do
    number = format_number(locale, entry)

    formatted =
      if entry.amount_in_cents >= 0 do
        format_positive(symbol, locale, number)
      else
        format_negative(symbol, locale, number)
      end

    formatted |> String.pad_leading(14, " ")
  end

  defp format_positive(symbol, :en_US, n), do: "  #{symbol}#{n} "
  defp format_positive(symbol, :nl_NL, n), do: " #{symbol} #{n} "
  defp format_negative(symbol, :en_US, n), do: " (#{symbol}#{n})"
  defp format_negative(symbol, :nl_NL, n), do: " #{symbol} -#{n} "

  defp compute_date(date) do
    year = date.year |> Kernel.to_string()
    month = date.month |> Kernel.to_string() |> String.pad_leading(2, "0")
    day = date.day |> Kernel.to_string() |> String.pad_leading(2, "0")
    {year, month, day}
  end

  defp format_date(:en_US, year, month, day), do: month <> "/" <> day <> "/" <> year <> " "
  defp format_date(_, year, month, day), do: day <> "-" <> month <> "-" <> year <> " "

  defp format_number(locale, entry) do
    cents = entry.amount_in_cents
    whole = entry.amount_in_cents |> Kernel.div(100) |> Kernel.abs()
    format_whole(whole, locale) <> compute_decimal_separator(locale) <> format_cents(cents)
  end

  defp format_whole(amount, _) when amount < 1000, do: amount |> to_string()

  defp format_whole(amount, locale) do
    compute_thousands(amount) <> compute_thousands_separator(locale) <> compute_reminder(amount)
  end

  defp compute_thousands(integer), do: div(integer, 1000) |> to_string()
  defp compute_reminder(integer), do: rem(integer, 1000) |> to_string()

  defp compute_decimal_separator(:en_US), do: "."
  defp compute_decimal_separator(:nl_NL), do: ","

  defp compute_thousands_separator(:en_US), do: ","
  defp compute_thousands_separator(:nl_NL), do: "."

  defp format_cents(cents) do
    cents |> abs |> rem(100) |> to_string() |> String.pad_leading(2, "0")
  end
end

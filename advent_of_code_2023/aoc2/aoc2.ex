defmodule DayTwo do
  @colors %{red: 12, green: 13, blue: 14}

  def compute_id(line) do
    line
    |> String.split(":")
    |> Enum.at(0)
    |> String.split(" ")
    |> Stream.map(&String.trim/1)
    |> Enum.at(1)
    |> Integer.parse()
    |> elem(0)
  end

  def is_game_ok(line), do: line |> get_play() |> Enum.all?(&is_ok/1)

  def compute_power(line) do
    max_green =
      line
      |> get_play()
      |> Stream.map(&color_tuple/1)
      |> max_color(green())

    max_red =
      line
      |> get_play()
      |> Stream.map(&color_tuple/1)
      |> max_color(red())

    max_blue =
      line
      |> get_play()
      |> Stream.map(&color_tuple/1)
      |> max_color(blue())

    max_green * max_red * max_blue
  end

  defp max_color(tuple, color) do
    tuple
    |> Stream.filter(&(&1 |> elem(1) == color))
    |> Stream.map(&elem(&1, 0))
    |> Enum.max()
  end

  defp get_play(line) do
    line
    |> String.split(":")
    |> Enum.at(1)
    |> String.split(";")
    |> Stream.flat_map(&String.split(&1, ","))
  end

  defp is_ok(play) do
    {number, max} = play |> color_tuple()
    number <= max
  end

  defp color_tuple(play) do
    split = play |> String.split(" ", trim: true) |> Stream.map(&String.trim/1)
    {split |> Enum.at(0) |> Integer.parse() |> elem(0), split |> Enum.at(1) |> parse_color()}
  end

  defp parse_color("red"), do: red()
  defp parse_color("green"), do: green()
  defp parse_color("blue"), do: blue()

  defp green, do: colors().green
  defp red, do: colors().red
  defp blue, do: colors().blue
  defp colors, do: @colors
end

result_one =
  File.stream!("aoc2.txt")
  |> Stream.filter(&DayTwo.is_game_ok/1)
  |> Stream.map(&DayTwo.compute_id/1)
  |> Enum.sum()

result_two =
  File.stream!("aoc2.txt")
  |> Stream.map(&DayTwo.compute_power/1)
  |> Enum.sum()

IO.puts(result_one)
IO.puts(result_two)

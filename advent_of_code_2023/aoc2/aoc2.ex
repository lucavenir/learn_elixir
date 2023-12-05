defmodule DayTwo do
  @max_red 12
  @max_green 13
  @max_blue 14

  def compute_id(line) do
    {number, _} =
      line
      |> String.split(":")
      |> Stream.map(&String.trim/1)
      |> Enum.at(0)
      |> String.split(" ")
      |> Stream.map(&String.trim/1)
      |> Enum.at(1)
      |> Integer.parse()

    number
  end

  def is_game_ok(line) do
    line
    |> String.split(":")
    |> Stream.map(&String.trim/1)
    |> Enum.at(1)
    |> String.split(";")
    |> Stream.map(&String.trim/1)
    |> Stream.flat_map(&String.split(&1, ","))
    |> Stream.map(&String.trim/1)
    |> Enum.all?(&is_ok/1)
  end

  defp is_ok(play) do
    split = play |> String.split(" ")
    {number, _} = split |> Enum.at(0) |> String.trim() |> Integer.parse()

    max =
      case split |> Enum.at(1) |> String.trim() do
        "red" -> @max_red
        "green" -> @max_green
        "blue" -> @max_blue
      end

    number <= max
  end
end

result_one =
  File.stream!("aoc2.txt")
  |> Stream.filter(&DayTwo.is_game_ok/1)
  |> Stream.map(&DayTwo.compute_id/1)
  |> Enum.sum()

# result_two =
#   File.stream!("aoc2.txt") |> Enum.map(&DayTwo.retrieve_number_but_fancy/1) |> Enum.sum()

IO.puts(result_one)
# IO.puts(result_two)

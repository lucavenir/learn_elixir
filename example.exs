defmodule Goofy do
  def lol(input) do
    input <> ", aghioh!"
  end

  defp asd(input) do
    input <> ", woopsie daisy!"
  end
end

IO.puts(Goofy.lol("heyas"))
# error
IO.puts(Goofy.asd("uh oh"))

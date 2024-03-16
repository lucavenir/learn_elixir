defmodule LearnMixTest do
  use ExUnit.Case
  doctest LearnMix

  test "greets the world" do
    assert LearnMix.hello() == :world
  end
end

defmodule HelloWorldTest do
  use ExUnit.Case

  test "says 'Hello, World!'" do
    assert HelloWorld.hello() == "Hello, World!"
  end

  test "I can add stuff" do
    assert HelloWorld.add(1, 2) == 3
  end
end

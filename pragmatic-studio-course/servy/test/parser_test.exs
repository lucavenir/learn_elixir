defmodule ParserTest do
  use ExUnit.Case, async: true

  import Servy.Parser

  doctest Servy.Parser

  test "greets the world" do
    header_lines = ["A: 1", "B: 2", "C: 3"]

    assert parse_headers(header_lines) == %{"A" => "1", "B" => "2", "C" => "3"}
  end
end

defmodule Username do
  def sanitize([]), do: ~c""

  def sanitize([head | tail]) do
    case head do
      ?_ -> [head | sanitize(tail)]
      ?ä -> ~c"ae" ++ sanitize(tail)
      ?ö -> ~c"oe" ++ sanitize(tail)
      ?ü -> ~c"ue" ++ sanitize(tail)
      ?ß -> ~c"ss" ++ sanitize(tail)
      head when head >= ?a and head <= ?z -> [head | sanitize(tail)]
      _ -> sanitize(tail)
    end
  end
end

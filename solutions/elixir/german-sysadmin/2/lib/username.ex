defmodule Username do
  def sanitize(username, accum \\ ~c"")
  def sanitize(~c"", accum), do: Enum.reverse(accum)
  def sanitize([head | tail], accum) when (?a <= head and head <= ?z) or head == ?_, do: sanitize(tail, [head] ++ accum)
  def sanitize([head | tail], accum) when head in [?ä, ?ö, ?ü, ?ß] do
    letter = case head do
      ?ä -> ~c"ae"
      ?ö -> ~c"oe"
      ?ü -> ~c"ue"
      ?ß -> ~c"ss"
    end

    sanitize(tail, Enum.reverse(letter) ++ accum)
  end
  def sanitize([_head | tail], accum), do: sanitize(tail, accum)
end

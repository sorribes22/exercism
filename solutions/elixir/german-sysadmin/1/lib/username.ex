defmodule Username do
  def sanitize(username, accum \\ ~c"")
  def sanitize(~c"", accum), do: Enum.reverse(accum)
  def sanitize([head | tail], accum) when (97 <= head and head <= 122) or head == 95, do: sanitize(tail, [head] ++ accum)
  def sanitize([head | tail], accum) when head in [228, 246, 252, 223] do
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

y = 1900

Stream.iterate(0, &(&1+1))
|> Stream.transform(1, fn m, d ->
     e = case {rem(m, 12)+1, div(m, 12) + y} do
         {2, y} when rem(y, 400) == 0   -> 29
         {2, y} when rem(y, 100) == 0   -> 28
         {2, y} when rem(y, 4) == 0     -> 29
         {2, _}                         -> 28
         {x, _} when x in [4, 6, 9, 11] -> 30
         _                              -> 31
       end
       |> Kernel.+(d)
       |> rem(7)
     {[d], e}
  end)
|> Stream.drop(12)
|> Stream.take(1200)
|> Enum.count(&(&1 == 0))
|> IO.inspect
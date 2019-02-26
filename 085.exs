target = 2_000_000

Euler.count_stream
|> Stream.take_while(&(Euler.rectangles(&1, &1) < target))
|> Stream.map(fn x ->
     Euler.count_stream(x)
     |> Stream.map(&({&1, x, abs(Euler.rectangles(&1, x) - target)}))
     |> Enum.reduce_while({0, 0, target}, fn x, a ->
          if elem(x, 2) < elem(a, 2), do: {:cont, x}, else: {:halt, a}
        end)
   end)
|> Enum.min_by(&elem(&1, 2))
|> Tuple.delete_at(2)
|> Tuple.to_list
|> Euler.product
|> IO.puts
Euler.count_stream
|> Stream.flat_map(fn x -> [1, 2*x, 1] end)
|> Enum.take(99)
|> Enum.reverse
|> Enum.concat([2])
|> Enum.reduce({1, 0}, fn x, {n, d} -> {d + x*n, n} end)
|> elem(0)
|> Integer.digits
|> Enum.sum
|> IO.puts
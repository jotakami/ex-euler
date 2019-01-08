Enum.map_reduce(1..100, 0, fn n, sum -> {2*sum*n, sum+n} end)
|> elem(0)
|> Enum.sum
|> IO.puts
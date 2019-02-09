Stream.reject(2..10000, fn x -> :math.sqrt(x) == trunc(:math.sqrt(x)) end)
|> Stream.map(&Enum.count(tl(Euler.root_cont_fraction(&1))))
|> Stream.filter(&(rem(&1, 2) == 1))
|> Enum.count
|> IO.puts
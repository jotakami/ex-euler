Euler.pythagorean_triples
|> Enum.find(fn {a, b, c} -> a+b+c == 1000 end)
|> Tuple.to_list
|> Euler.product
|> IO.puts
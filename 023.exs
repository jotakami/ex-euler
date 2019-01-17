limit = 28123
p = Primes.list(limit)
a = Enum.filter(1..limit, &Euler.abundant?(&1, p))
Stream.filter(a, &(&1 <= limit/2))
|> Stream.transform(a, fn n, b ->
     Enum.map(b, &(&1+n))
     |> Enum.filter(&(&1 <= limit))
     |> Tuple.duplicate(1)
     |> Tuple.append(Enum.drop(b, 1))
   end)
|> Enum.sort
|> Enum.dedup
|> Enum.sum
|> Kernel.*(-1)
|> Kernel.+(div(limit*(limit+1), 2))
|> IO.puts
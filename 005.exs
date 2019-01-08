Enum.map(2..20, &(Primes.factorize(&1) |> Enum.to_list))
|> Enum.reduce(fn f, g ->
     List.myers_difference(g, f)
     |> Enum.flat_map(&elem(&1, 1))
     |> Enum.sort
   end)
|> Enum.reduce(&*/2)
|> IO.inspect
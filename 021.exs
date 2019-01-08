n = 10_000
m = Stream.map(2..n-1, fn x -> {x, Euler.factors(x) |> Enum.sum |> Kernel.-(x)} end)
  |> Map.new
Enum.reduce(2..n-1, 0, &if(Map.get(m, &1) != &1 and Map.get(m, Map.get(m, &1)) == &1, do: &1 + &2, else: &2))
|> IO.puts
limit = 1_000_000

Stream.iterate(1, &(&1+1))
|> Stream.take(limit-1)
|> Enum.reduce(Map.new([{1, 1}]), &Euler.collatz_count(&2, &1))
|> Enum.max_by(fn {k, v} -> if(k < limit, do: v, else: 0) end)
|> elem(0)
|> IO.puts
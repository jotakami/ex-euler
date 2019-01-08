limit = 2_000_000

Primes.list(limit)
|> Enum.sum
|> IO.puts
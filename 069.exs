Euler.totient(Primes.list(1000))
|> Stream.zip(Euler.count_stream(2))
|> Stream.map(fn {t, n} -> n / t end)
|> Stream.take(999_999)
|> Euler.max_index
|> Kernel.+(2)
|> IO.puts
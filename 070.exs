Euler.totient(Primes.list(4000))
|> Stream.zip(Euler.count_stream(2))
|> Stream.take(9_999_999)
|> Stream.filter(fn {t, n} -> Euler.perm?(Integer.digits(t), Integer.digits(n)) end)
|> Enum.min_by(fn {t, n} -> n / t end)
|> elem(1)
|> IO.puts
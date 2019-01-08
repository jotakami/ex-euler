primes = Primes.list(2_000_000)

Euler.spiral_stream(1)
|> Stream.transform({0, 1}, fn x, {p, t} ->
     p = if(Primes.is_prime(x, primes), do: p+1, else: p)
     {[p/t], {p, t+1}}
   end)
|> Stream.take_every(4)
|> Enum.find_index(fn x -> x > 0 and x < 0.10 end)
|> Kernel.*(2)
|> Kernel.+(1)
|> IO.inspect
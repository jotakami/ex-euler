target = 8
primes = Primes.list(1000)

Primes.stream
|> Enum.find(fn p ->
     Euler.digit_replacements(p, target)
     |> Enum.map(&tl/1)
     |> Enum.any?(&Enum.reduce_while(&1, length(&1), fn x, a ->
          cond do
            Primes.is_prime(x, primes) -> {:cont, a}
            a < target                 -> {:halt, false}
            true                       -> {:cont, a-1}
          end
        end))
   end)
|> IO.puts
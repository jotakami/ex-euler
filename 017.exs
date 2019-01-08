Enum.map(1..1000, &Euler.letter_count/1)
|> Enum.sum
|> IO.puts
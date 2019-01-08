Fibonacci.stream
|> Stream.take_while(&(&1 < 4_000_000))
|> Stream.drop(1)
|> Stream.take_every(3)
|> Enum.to_list
|> Enum.sum
|> IO.puts
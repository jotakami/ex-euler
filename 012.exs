Euler.triangle_stream
|> Stream.map(&({&1, Euler.factors(&1) |> Enum.count}))
|> Enum.find(&(elem(&1, 1) > 500))
|> elem(0)
|> IO.puts
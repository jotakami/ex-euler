Enum.map(1..999, &Euler.repetend_period/1)
|> Enum.each(&IO.puts/1)
# |> Enum.max_by(fn {l, _} -> l end)
# |> IO.inspect
Stream.reject(2..1000, &Euler.is_square/1)
|> Stream.map(fn d ->
     Euler.root_convergents(d)
     |> Enum.find(fn {h, k} -> h*h - d*k*k == 1 end)
     |> Tuple.append(d)
   end)
|> Enum.max_by(fn {x, _, d} -> x end)
|> elem(2)
|> IO.puts
Stream.iterate(2, fn x -> if(Euler.is_square(x+1), do: x+2, else: x+1) end)
|> Stream.take_while(fn x -> x <= 1000 end)
|> Stream.map(fn d ->
     :math.sqrt(d)
     |> trunc
     |> Kernel.+(1)
     |> Stream.iterate(&(&1+1))
     |> Enum.find_value(fn x -> if(Euler.is_square((:math.pow(x, 2)-1)/d), do: x, else: false) end)
     |> Tuple.duplicate(1)
     |> Tuple.append(d)
   end)
|> Enum.reduce({0, 0}, fn {x, d}, {max, dmax} -> if(x > max, do: {x, d}, else: {max, dmax}) end)
|> elem(1)
|> IO.puts
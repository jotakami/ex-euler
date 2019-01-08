Euler.palindromes(999)
|> Enum.find(fn p ->
     Euler.factors(p)
     |> Enum.filter(&Euler.digits?(&1, 3))
     |> Enum.any?(fn f -> div(p, f) |> Euler.digits?(3) end)
   end)
|> IO.puts
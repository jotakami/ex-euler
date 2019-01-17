Fibonacci.stream
|> Enum.find_index(fn x -> length(Integer.digits(x)) == 1000 end)
|> Kernel.+(1)
|> IO.puts
target = 60
memo = Map.new([
  {   169, 3},
  {   871, 2},
  {   872, 2},
  {  1454, 3},
  { 45361, 2},
  { 45362, 2},
  {363601, 3}
])
Euler.count_stream
|> Stream.take(999999)
|> Enum.reduce({0, memo}, fn x, {c, memo} ->
     {n, memo} = Euler.digit_factorial_chain(x, memo)
     if n == target, do: {c+1, memo}, else: {c, memo}
   end)
|> elem(0)
|> IO.puts
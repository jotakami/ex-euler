import Bitwise
exp = 1_000
Integer.digits(1 <<< exp)
|> Enum.sum
|> IO.puts
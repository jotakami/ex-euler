with {:ok, f} <- File.read("p022_names.txt") do
  String.replace(f, "\"", "")
  |> String.split(",")
  |> Enum.sort
  |> Stream.transform(1, fn n, m ->
       String.to_charlist(n)
       |> Enum.map(&(&1 - 64))
       |> Enum.sum
       |> Kernel.*(m)
       |> List.wrap
       |> Tuple.duplicate(1)
       |> Tuple.append(m+1)
     end)
  |> Enum.sum
  |> IO.inspect
end
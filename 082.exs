with {:ok, f} <- File.read("p082_matrix.txt") do
  m = Matrix.from_csv(f) |> Matrix.transpose
  Enum.reverse(m.m)
  |> Enum.reduce(fn col, right ->
       z = Enum.zip(col, right)
       Enum.reverse(z)
       |> Euler.min_grid_path
       |> Enum.reverse
       |> Enum.zip(Euler.min_grid_path(z))
       |> Enum.map(fn {l, r} -> min(l, r) end)
     end)
  |> Enum.min
  |> IO.inspect
end
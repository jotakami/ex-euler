with {:ok, f} <- File.read("p081_matrix.txt") do
  m = Matrix.from_csv(f) |> Matrix.transpose |> Map.get(:m) |> Enum.reverse
  r = hd(m) |> Enum.reverse |> Enum.scan(&(&1 + &2)) |> Enum.reverse
  Enum.reduce(tl(m), r, fn col, right ->
    Enum.zip(col, right)
    |> Enum.reverse
    |> Euler.min_grid_path
    |> Enum.reverse
  end)
  |> hd
  |> IO.inspect
end
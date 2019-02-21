with {:ok, f} <- File.read("p083_matrix.txt"),
     m        <- Matrix.from_csv(f)
do
  Matrix.rotate(m)
  |> Matrix.init_path_sums
  |> Matrix.min_path
  |> Matrix.rotate
  |> Matrix.iter_min_path
  |> IO.inspect
end
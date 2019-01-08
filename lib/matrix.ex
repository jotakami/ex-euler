defmodule Matrix do
  defstruct m: [[]], r: 0, c: 0
  
  @type t :: %Matrix{
    m: [[float]],
    r: non_neg_integer,
    c: non_neg_integer
  }

  def from_string(s) do
    String.trim(s)
    |> String.split("\r\n")
    |> Enum.map(fn s -> String.split(s) |> Enum.map(&String.to_integer/1) end)
    |> check_rows
  end
  
  defp check_rows(m) do
    c = length(hd(m))
    if Enum.all?(m, fn r -> length(r) == c end) do
      %Matrix{m: m, r: length(m), c: c}
    else
      :error
    end
  end
  
  def transpose(m) do
    %Matrix{m: pivot(m.m), r: m.c, c: m.r}
  end
  
  def diagonals(m) do
    Enum.concat(m.m)
    |> Enum.chunk_every(m.c+1)
    |> pivot
    |> Stream.transform(m.r, fn r, n ->
         if n < min(m.r, m.c) and n > 0 do
           [Enum.take(r, n)]
           |> Enum.concat(Enum.drop(r, n) |> Enum.chunk_every(m.c))
           |> Tuple.duplicate(1)
           |> Tuple.append(n-1)
         else
           {Enum.chunk_every(r, m.c), n-1}
         end
       end)
    |> Enum.to_list
  end
  
  def pivot(lists) do
    Enum.reduce(lists, List.duplicate([], length(hd(lists))), fn a, b ->
         Enum.map_reduce(b, a, fn
           y, [x | r] -> {[x | y], r}
           y, []      -> {y, []}
         end)
         |> elem(0)
       end)
    |> Enum.map(&Enum.reverse/1)
  end
end
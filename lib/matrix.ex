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
  
  def from_csv(s) do
    String.split(s)
    |> Enum.map(fn s -> String.split(s, ",") |> Enum.map(&String.to_integer/1) end)
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
  
  def rotate(m) do
    Map.put(m, :m, Enum.reverse(m.m) |> Enum.map(&Enum.reverse/1))
  end
  
  def min_path(m) do
    acc = hd(m.m)
      |> Enum.unzip
      |> elem(1)
      |> Enum.max
      |> List.duplicate(m.c)
    m2 = Enum.map_reduce(m.m, acc, fn row, prev ->
        row = Enum.zip(row, prev)
          |> Enum.map_reduce(hd(prev), fn {{x, c}, l}, u ->
               n = Enum.min([c, x+l, x+u])
               {{x, n}, n}
             end)
          |> elem(0)
        {row, Enum.unzip(row) |> elem(1)}
      end)
      |> elem(0)
    Map.put(m, :m, m2)
  end
  
  def iter_min_path(m) do
    m2 = min_path(m)
      |> rotate
      |> min_path
      |> rotate
    if hd(hd(m.m)) == hd(hd(m2.m)), do: m2, else: iter_min_path(m2)
  end
  
  def init_path_sums(m) do
    max = Enum.map(m.m, &Enum.sum/1) |> Enum.sum
    sink = hd(hd(m.m))
    am = Enum.map(m.m, fn row -> Enum.map(row, &({&1, max})) end)
    Map.put(m, :m, List.replace_at(am, 0, List.replace_at(hd(am), 0, {sink, sink})))
  end
end
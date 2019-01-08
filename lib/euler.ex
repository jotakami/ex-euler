defmodule Euler do
  @moduledoc """
  This module defines general-purpose functions used in solving Project Euler challenges.
  """

  @doc """
  Calculates the sum of all natural numbers less than max which have any of the given factors.
  """
  @spec sum_multiples([pos_integer, ...], pos_integer) :: non_neg_integer
  def sum_multiples(factors, max) do
    Enum.filter(1..max-1, &Enum.any?(factors, fn f -> rem(&1, f) == 0 end))
    |> Enum.sum
  end
  
  def factors(1), do: [1]
  def factors(n) when n > 1 do
    pf = Primes.factorize(n) |> Enum.to_list
    factors(pf, 1)
    |> Enum.sort
  end
  
  defp factors([], f), do: [f]
  defp factors(pf, f) do
    Enum.dedup(pf)
    |> Enum.flat_map(fn p -> Enum.drop_while(pf, &(&1 < p)) |> tl |> factors(f*p) end)
    |> List.insert_at(-1, f)
  end
  
  def factor_pairs(n) do
    f = factors(n)
    Enum.zip(f, Enum.reverse(f))
    |> Enum.take(round(length(f)/2))
  end
  
  def palindromes(x) do
    Stream.unfold(x, fn x ->
      Integer.digits(x)
      |> Enum.concat(Integer.digits(x) |> Enum.reverse)
      |> Integer.undigits
      |> List.wrap
      |> List.insert_at(-1, x-1)
      |> List.to_tuple
    end)
  end
  
  def digits?(n, d), do: length(Integer.digits(n)) == d
  
  def digit_sum(n) when is_integer(n), do: Integer.digits(n) |> Enum.sum
  
  def product([]), do: 1
  def product(list), do: Enum.reduce(list, &*/2)
  
  def stream_product(digits, k) do
    Stream.transform(digits, {0, []}, fn
      0, _           -> {[], {0, []}}
      x, {0, _}      -> {[], {x, [x]}}
      x, {p, buffer} when length(buffer) == k ->
        p = x*div(p, hd(buffer))
        {[p], {p, tl(buffer) ++ [x]}}
      x, {p, buffer} -> {[], {x*p, buffer ++ [x]}}
    end)
  end
  
  def factorial(0), do: 1
  def factorial(n) when n > 0, do: product(1..n)
  
  def pythagorean_triples() do
    Stream.iterate(2, &(&1+2))
    |> Stream.flat_map(fn r ->
         Euler.factor_pairs(div(r*r, 2))
         |> Enum.map(fn {s, t} -> {r+s, r+t, r+s+t} end)
       end)
  end
  
  def spiral_stream(n) do
    Stream.iterate(n, &next_spiral/1)
  end
  
  def next_spiral(n), do: (trunc(:math.sqrt(n) + 1) |> div(2)) * 2 + n
  
  def is_square(x), do: :math.sqrt(x) |> trunc |> :math.pow(2) |> Kernel.==(x)
  
  def count_stream(), do: Stream.iterate(1, &(&1+1))
  
  def triangle_stream(), do: count_stream() |> Stream.scan(&(&1+&2))
  
  def collatz(1), do: nil
  def collatz(n) when rem(n, 2) == 1, do: 3*n+1
  def collatz(n), do: div(n, 2)
  
  def collatz_count(m, x) when x > 0 do
    if Map.has_key?(m, x) do
      m
    else
      y = collatz(x)
      m = collatz_count(m, y)
      Map.put(m, x, Map.get(m, y) + 1)
    end
  end
  
  def comb(_, 0), do: 1
  def comb(n, 1), do: n
  def comb(n, r) when n == r, do: 1
  def comb(n, r) when n > r, do: div(product(r+1..n), product(1..n-r))
  
  def letter_count(n) do
    cond do
      n < 10        -> Enum.at([0, 3, 3, 5, 4, 4, 3, 5, 5, 4], n)
      n < 20        -> Enum.at([3, 6, 6, 8, 8, 7, 7, 9, 8, 8], n-10)
      n < 100       -> Enum.at([6, 6, 5, 5, 5, 7, 6, 6], div(n, 10)-2) + letter_count(rem(n, 10))
      n < 1_000     -> letter_count(div(n, 100)) + if(rem(n, 100) == 0, do: 7, else: 10 + letter_count(rem(n, 100)))
      n < 1_000_000 -> letter_count(div(n, 1000)) + 8 + letter_count(rem(n, 1000))
    end
  end
end
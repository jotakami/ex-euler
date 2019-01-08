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
  
  def factors(n) do
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
end
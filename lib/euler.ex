defmodule Euler do
  @moduledoc """
  This module defines general-purpose functions used in solving Project Euler challenges.
  """
  
  defmacro divides?(d, n) do
    quote do
      rem(unquote(n), unquote(d)) == 0
    end
  end

  @doc """
  Calculates the sum of all natural numbers less than max which have any of the given factors.
  """
  @spec sum_multiples([pos_integer, ...], pos_integer) :: non_neg_integer
  def sum_multiples(factors, max) do
    Enum.filter(1..max-1, &Enum.any?(factors, fn f -> rem(&1, f) == 0 end))
    |> Enum.sum
  end
  
  def factors(n), do: factors(n, Primes.stream)
  def factors(1, _), do: [1]
  def factors(n, primes) when n > 1 do
    pf = Primes.factorize(n, primes) |> Enum.to_list
    expand_factors(pf, 1)
    |> Enum.sort
  end
  
  defp expand_factors([], f), do: [f]
  defp expand_factors(pf, f) do
    Enum.dedup(pf)
    |> Enum.flat_map(fn p -> Enum.drop_while(pf, &(&1 < p)) |> tl |> expand_factors(f*p) end)
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
  
  def count_stream(), do: count_stream(1)
  def count_stream(x), do: Stream.iterate(x, &(&1+1))
  
  def max_index(x) do
    max = Enum.max(x)
    Enum.find_index(x, &(&1 == max))
  end
  
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
  
  def abundant?(n), do: abundant?(n, Primes.stream)
  def abundant?(n, primes), do: factors(n, primes) |> Enum.sum |> Kernel.-(n) |> Kernel.>(n)
  
  def nth_lex_perm(chars, n), do: find_lex_perm(Enum.sort(chars), n-1)
  defp find_lex_perm([], 0), do: []
  defp find_lex_perm(chars, n) do
    r = factorial(length(chars)-1)
    {d, chars} = List.pop_at(chars, div(n, r))
    [d | find_lex_perm(chars, rem(n, r))]
  end
  
  def pow(_, 0), do: 1
  def pow(n, 1), do: n
  def pow(n, k) when rem(k, 2) == 0, do: pow(n*n, div(k, 2))
  def pow(n, k), do: n * pow(n, k-1)
  
  def mult_order(n, p) do
    Stream.iterate(n, &(&1*n))
    |> Enum.reduce_while([], fn x, a ->
         k = rem(x, p)
         case Enum.find_index(a, &(&1 == k)) do
           nil -> {:cont, a ++ [k]}
           i   -> {:halt, length(a) - i}
         end
       end)
  end
  
  def repetend_period(n) do
    f = Primes.factorize(n) |> Enum.to_list
    g = Enum.reject(f, &(&1 in [2, 5]))
    cond do
      g == []                   -> 0
      hd(f) == n                -> mult_order(10, n)
      length(Enum.uniq(f)) == 1 ->
        if divides?(product(f), pow(10, n-1)) do
          repetend_period(hd(f))
        else
          repetend_period(hd(f)) * product(f)
        end
      true ->
        Enum.chunk_by(g, &(&1))
        |> Enum.map(&repetend_period(product(&1)))
        |> lcm
    end
  end
  
  def gcd(0, _), do: 0
  def gcd(a, b) when a == b, do: a
  def gcd(a, b) when b > a, do: gcd(b, a)
  def gcd(a, b), do: gcd(a-b, b)
  
  def lcm(a, b), do: div(a*b, gcd(a, b))
  def lcm([]), do: 1
  def lcm(list) when is_list(list), do: lcm(hd(list), lcm(tl(list)))
  
  def digit_bases(n, d) do
    Stream.iterate(pow(10, n) + 1, fn x ->
      case rem(x, 10) do
        3 -> x + 4
        _ -> x + 2
      end
    end)
    |> Stream.filter(fn x ->
         digits = Integer.digits(x)
         zeros = Enum.count(digits, &(&1 == 0))
         ones = Enum.count(digits, &(&1 == 1))
         zeros >= d or (hd(digits) == 1 and ones >= d)
       end)
  end
  
  @doc """
  Returns a list of digit replacement families of size n or greater that can be generated from x.
  A digit replacement family is generated by replacing all copies of a given digit with each greater value.
  An example family for 20056 is [21156, 22256, 23356, 24456, 25556, 26656, 27756, 28856, 29956]
  """
  def digit_replacements(x, n) do
    digits = Integer.digits(x) |> Enum.reverse
    Enum.flat_map(0..10-n, fn d ->
      find_indices(digits, d)
      |> superset
      |> Enum.map(&Enum.reduce(&1, 0, fn y, a -> a + pow(10, y) end))
      |> Enum.map(fn y -> for(i <- 0..9-d, do: x + i * y) end)
    end)
  end
  
  @doc """
  Returns a list of all indices where x is found within list.
  """
  def find_indices(list, x) do
    Enum.with_index(list)
    |> Enum.filter(fn {y, _} -> x == y end)
    |> Enum.unzip
    |> elem(1)
  end
  
  @doc """
  Returns the superset of the input, excluding the null set.
  """
  def superset([]), do: []
  def superset(x) do
    s = superset(tl(x))
    Enum.concat([[[hd(x)]], s, Enum.map(s, &([hd(x)] ++ &1))])
  end
  
  def root_cont_fraction(n) do
    a0 = trunc(:math.sqrt(n))
    Stream.unfold({a0, a0, 1, []}, fn {an, b, c, history} ->
      if {an, b, c} in history do
        nil
      else
        history = history ++ [{an, b, c}]
        c = div(n - b*b, c)
        a = trunc((:math.sqrt(n) + b) / c)
        b = a*c - b
        {an, {a, b, c, history}}
      end
    end)
    |> Enum.to_list
  end
  
  def root_convergents(n) do
    a0 = trunc(:math.sqrt(n))
    Stream.unfold({a0, 1}, fn {b, c} ->
      c = div(n - b*b, c)
      a = trunc((:math.sqrt(n) + b) / c)
      b = a*c - b
      {a, {b, c}}
    end)
    |> Stream.transform({{1, a0}, {0, 1}}, fn a, {{p0, p1}, {q0, q1}} ->
         {p2, q2} = {a*p1 + p0, a*q1 + q0}
         {[{p2, q2}], {{p1, p2}, {q1, q2}}}
       end)
  end
  
  def totient(), do: totient(Primes.stream)
  def totient(primes) do
    count_stream(2)
    |> Stream.map(fn x ->
         Primes.factorize(x, primes)
         |> Enum.dedup
         |> Enum.reduce(x, &(div(&2, &1) * (&1-1)))
       end)
  end
  
  def perm?(x, y), do: Enum.sort(x) == Enum.sort(y)
end
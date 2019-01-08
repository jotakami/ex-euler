defmodule Primes do
  @moduledoc """
  This module defines functions for working with prime numbers.
  """
  
  def is_prime(n), do: is_prime(n, stream())
  def is_prime(2, _primes), do: true
  def is_prime(n, _primes) when n < 2, do: false
  def is_prime(n, primes) do
    Enum.find_value(primes, false, fn p ->
      cond do
        rem(n, p) == 0    -> {:ok, false}
        p > :math.sqrt(n) -> {:ok, true}
        true              -> false
      end
    end)
    |> elem(1)
  end
  
  @doc """
  Returns an infinite stream which generates the sequence of prime numbers.
  """
  @spec stream() :: Stream.t
  def stream() do
    Stream.unfold({%{}, 2}, fn {c, x} ->
      {c, p} = next_prime(c, x)
      {p, {c, p+1}}
    end)
  end
  
  @doc """
  Returns a stream of primes less than or equal to max, in ascending order.
  Uses bit operations to achieve high performance with low memory requirements.
  """
  @spec list(number) :: [pos_integer]
  def list(max) do
    s = max - 1
    fast_list(<<0::1, -1::size(s)>>, 2)
    |> Stream.unfold(fn
         <<bit::1, tail::bits>> -> {bit, tail}
         <<>>                   -> nil
       end)
    |> Stream.transform(1, fn
         0, n -> {[], n+1}
         1, n -> {[n], n+1}
       end)
  end
  
  defp fast_list(bits, x, offset \\ 0)
  defp fast_list(bits, x, offset) when bit_size(bits) >= x - offset do
    y = x - 1
    <<head::bits-size(y), bit::1, tail::bits>> = bits
    if bit == 1 do
      flip_every(tail, x, <<head::bits, bit::1>>)
      |> fast_list(x+1, offset)
    else
      fast_list(bits, x+1, offset)
    end
  end
  defp fast_list(bits, _x, _offset), do: bits
  
  defp flip_every(bits, n, head) do
    skip = n - 1
    case bits do
      <<chunk::bits-size(skip), _::1, tail::bits>> ->
        flip_every(tail, n, <<head::bits, chunk::bits, 0::1>>)
      bits ->
        <<head::bits, bits::bits>>
    end
  end
  
  @doc """
  Calculates the prime factorization of the given integer.
  """
  @spec factorize(pos_integer) :: [pos_integer, ...]
  def factorize(n) when n > 1 do
    Stream.transform(stream(), n, fn p, n ->
      cond do
        n == 1            -> {:halt, 1}
        p > :math.sqrt(n) -> {[n], 1}
        true              -> factor_helper(n, p, 0)
      end
    end)
  end
  
  defp factor_helper(n, p, k) when rem(n, p) == 0, do: factor_helper(div(n, p), p, k+1)
  defp factor_helper(n, p, k), do: {List.duplicate(p, k), n}
  
  defp next_prime(c, x) do
    if x in Map.keys(c) do
      Map.get(c, x)
      |> Enum.reduce(c, &Map.update(&2, x+&1, [&1], fn p -> p ++ [&1] end))
      |> Map.delete(x)
      |> next_prime(x+1)
    else
      {Map.put(c, x*x, [x]), x}
    end
  end
end
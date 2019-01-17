defmodule Fibonacci do
  @moduledoc """
  This module defines functions for working with the Fibonacci series.
  """
  
  @doc """
  Returns an infinite stream which generates the Fibonacci sequence.
  """
  @spec stream() :: Stream.t
  def stream() do
    Stream.unfold({1, 0}, fn {f, g} -> {f+g, {g, f+g}} end)
  end
end
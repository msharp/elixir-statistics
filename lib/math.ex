defmodule Math do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Math.Supervisor.start_link
  end

  @moduledoc """
  Provides som helpful mathematical functions
  """
  
  @doc """
  Sum the contents of a list

  ## Examples

    iex> Math.sum([1,2,3])
    6
  """
  def sum(list) do
    List.foldl(list, 0, fn (x, acc) -> x + acc end)
  end

  @doc """
  Calculate the mean from a list of numbers

  ## Examples
    
    iex> Math.mean([1,2,3])
    2
  """
  def mean(list) do
    sum(list) / Enum.count(list)
  end

  @doc """
  Get the median value from a list

  ## Examples
  
    iex> Math.median([1,2,3])
    2
    iex> Math.median([1,2,3,4])
    2.5

  """
  def median(list) do
    sorted = :lists.sort(list)
    middle = (Enum.count(list) - 1) / 2
    median(sorted, middle, 0, [])
  end
  # for when we haven't reached the mid-point(s)
  defp median(list, middle, pos, acc) when pos < :erlang.trunc(middle) do
    [_|tail] = list
    pos = pos + 1
    median(tail, middle, pos, acc)
  end
  # for the case when there is a definite middle point
  defp median(list, middle, pos, _) when pos == middle do
    [head|_] = list
    head
  end
  # we've passed the midpoint for a two-item median
  defp median(list, middle, pos, acc) when pos > middle do
    [head|_] = list
    mean([head|acc])
  end
  # we've reached the first of the two middle values
  defp median(list, middle, pos, _) when pos == :erlang.trunc(middle) do
    [head|tail] = list
    pos = pos + 1
    median(tail, middle, pos, [head])
  end
  

  @doc """
  Get square root from Erlang
  """
  def sqrt(num) do
    :math.sqrt(num)
  end

end

defmodule Math do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Math.Supervisor.start_link
  end

  @moduledoc """
  Provides some helpful mathematical/statistics functions
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
  defp median([_|t], middle, pos, acc) when pos < :erlang.trunc(middle) do
    pos = pos + 1
    median(t, middle, pos, acc)
  end
  # for the case when there is a definite middle point
  defp median([h|_], middle, pos, _) when pos == middle do
    h
  end
  # we've passed the midpoint for a two-item median
  defp median([h|_], middle, pos, acc) when pos > middle do
    mean([h|acc])
  end
  # we've reached the first of the two middle values
  defp median([h|t], middle, pos, _) when pos == :erlang.trunc(middle) do
    pos = pos + 1
    median(t, middle, pos, [h])
  end

  @doc """
  Get the minimum value from a list

  ## Examples
      
      iex> Math.min([3,4,2,1,2,3,5,2])
      1

  """
  def min(list) do
    hd(Enum.sort(list))
  end

  @doc """
  Get the maximum value from a list

  ## Examples
      
      iex> Math.max([3,4,2,1,2,3,5,2])
      5

  """
  def max(list) do
    l = Enum.sort(list)
    hd(Enum.reverse(l))
  end

  @doc """
  Get the quartile cutoff value from a list
  """
  def quartile(list,quartile) when quartile == :first do
    {l,_} = split_list(list)
    median(l)
  end
  def quartile(list,quartile) when quartile == :third do
    {_,l} = split_list(list)
    median(l)
  end

  @doc """
  Split a list into two equal lists.
  Needed for getting the quartiles.
  """
  defp split_list(list) do
    lst = Enum.sort(list)
    split_list(lst,[],[])
  end
  defp split_list([],lower,upper) do
    {lower,upper}
  end
  defp split_list([h|t],[],[]) do
    lower = [h]
    split_list(t,lower,[])
  end
  defp split_list([h|t],lower,upper) do
    cond do
      Enum.count(lower) < Enum.count(t) ->
        lower = [h|lower]
      Enum.count(lower) == Enum.count(t) ->
        lower = [h|lower]
        upper = [h]
      upper == [] ->
        upper = [h]
      true ->
        upper = [h|upper]
    end
    split_list(t,lower,upper)
  end

  @doc """
  Get square root from Erlang

  ## Examples

      iex> Math.sqrt(64)
      8.0

  """
  def sqrt(num) do
    :math.sqrt(num)
  end


  @doc """
  Calculate variance from a list of numbers

  ## Examples

      iex> Math.variance([1,2,3,4])
      1.25

  """
  def variance(list) do
    mean = mean(list)
    squared_diffs = Enum.map(list, fn(x) -> (mean - x) * (mean - x) end)
    sum(squared_diffs) / Enum.count(list)
  end

  @doc """
  Calculate the standard deviation of a list

  ## Examples

      iex> Math.stdev([1,2])
      0.5

  """
  def stdev(list) do
    sqrt(variance(list))
  end

end

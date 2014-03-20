defmodule Statistics.Descriptive do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Statistics.Supervisor.start_link
  end

  @moduledoc """
  Provides some helpful mathematical/statistics functions
  """
  
  @doc """
  Sum the contents of a list

  ## Examples

      iex> Statistics.Descriptive.sum([1,2,3])
      6

  """
  def sum(list) do
    List.foldl(list, 0, fn (x, acc) -> x + acc end)
  end

  @doc """
  Calculate the mean from a list of numbers

  ## Examples
    
      iex> Statistics.Descriptive.mean([1,2,3])
      2

  """
  def mean(list) do
    sum(list) / Enum.count(list)
  end

  @doc """
  Get the median value from a list

  ## Examples
  
      iex> Statistics.Descriptive.median([1,2,3])
      2
      iex> Statistics.Descriptive.median([1,2,3,4])
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
  Get the mode
  
  ## Examples

    iex> Statistics.Descriptive.mode([1,2,3,2,4,5,2,6,7,2,8,9]) 
    2

  """
  def mode(list) do
    mode(list,{0,0})
  end
  defp mode([],champ) do
    {val,_} = champ
    val
  end
  defp mode([h|t],champ) do
    {count,list} = mode_count_and_remove(h,t)
    {_,champ_count} = champ
    {_,new_count} = count
    if new_count > champ_count do
      champ = count
    end
    mode(list,champ)
  end
  defp mode_count_and_remove(val,list) do
    {count,new_list} = mode_count_and_remove(val,1,list,[])
    {{val,count},new_list}
  end
  defp mode_count_and_remove(val, count, [h|t], new_list) do
    if val == h do
      mode_count_and_remove(val,count+1,t,new_list)
    else
      mode_count_and_remove(val,count,t,[h|new_list])
    end
  end
  defp mode_count_and_remove(_, count, [], new_list) do
    {count,new_list}
  end

  @doc """
  Get the minimum value from a list

  ## Examples
      
      iex> Statistics.Descriptive.min([3,4,2,1,2,3,5,2])
      1

  """
  def min(list) do
    hd(Enum.sort(list))
  end

  @doc """
  Get the maximum value from a list

  ## Examples
      
      iex> Statistics.Descriptive.max([3,4,2,1,2,3,5,2])
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
  Get range of data
  """
  def range(list) do
    max(list) - min(list)
  end

  @doc """
  Calculate the inter-quartile range
  """
  def iqr(list) do
    quartile(list,:third) - quartile(list,:first)
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

      iex> Statistics.Descriptive.sqrt(64)
      8.0

  """
  def sqrt(num) do
    :math.sqrt(num)
  end


  @doc """
  Calculate variance from a list of numbers

  ## Examples

      iex> Statistics.Descriptive.variance([1,2,3,4])
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

      iex> Statistics.Descriptive.stdev([1,2])
      0.5

  """
  def stdev(list) do
    sqrt(variance(list))
  end

  @doc  """
  Calculates the nth moment about the mean for a sample.

  Generally used to calculate coefficients of skewness and  kurtosis.
  Returns the n-th central moment as a float
  The denominator for the moment calculation is the number of
  observations, no degrees of freedom correction is done.

  ## Examples

      iex> Statistics.Descriptive.moment([1,2,3,4,5,6,7,8,9,8,7,6,5,4,3],3) 
      -1.3440000000000025

  """
  def moment(list, moment \\ 1) do
    if moment == 1 do 
      # By definition the first moment about the mean is 0.
      0.0
    else
      mn = mean(list)
      s = Enum.map(list, fn(x) -> :math.pow((x - mn), moment) end)
      mean(s)
    end
  end

end

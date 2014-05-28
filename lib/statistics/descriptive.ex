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
      2.0

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

  responds to only first and third quartile.

  ## Examples

      iex>  Statistics.Descriptive.quartile([1,2,3,4,5,6,7,8,9],:first) 
      3
      iex>  Statistics.Descriptive.quartile([1,2,3,4,5,6,7,8,9],:third)
      7

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
  Get the nth percentile cutoff from a list

  ## Examples
  
      iex> Statistics.Descriptive.percentile([1,2,3,4,5,6,7,8,9],80)
      7.4
      iex> Statistics.Descriptive.percentile([1,2,3,4,5,6,7,8,9],100)
      9

  """
  def percentile(list,n) when is_number(n) do
    case n do
      0 ->
        Enum.min(list)
      100 ->
        Enum.max(list)
      _ ->
        l = Enum.sort(list)
        rank = n/100.0 * (Enum.count(list)-1)
        f_rank = Float.floor(rank)
        {:ok,lower} = Enum.fetch(l,f_rank)
        {:ok,upper} = Enum.fetch(l,f_rank+1)
        lower + (upper - lower) * (rank - f_rank)
    end
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
  def split_list(list) do
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

  @doc """
  Calculate the trimmed mean of a list. 
  Can specify cutoff values as a tuple, 
  or simply choose the IQR min/max as the cutoffs

  ## Examples
  
    iex> Statistics.Descriptive.trimmed_mean([1,2,3],{1,3})
    2.0

  """
  def trimmed_mean(list, {low,high}) do
    tl = Enum.reject(list, fn(x) -> x < low or x > high end)
    mean(tl)
  end
  def trimmed_mean(list, range) when range == :iqr do
    q1 = quartile(list,:first)
    q3 = quartile(list,:third)
    trimmed_mean(list,{q1,q3})
  end
  def trimmed_mean(list) do
    mean(list)
  end

  @doc """
  Calculates the harmonic mean from a list

  Harmonic mean is the number of values divided by 
  the sum of the reciprocal of all the values.

  ## Examples
  
      iex> Statistics.Descriptive.harmonic_mean([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]) 
      4.5204836768674568

  """
  def harmonic_mean(list) do
    r = Enum.map(list, fn(x) -> 1/x end)
    Enum.count(list) / Enum.sum(r)
  end

  @doc """
  Calculate the geometric mean of a list

  Geometric mean is the nth root of the product of n values

  ## Examples

      iex> Statistics.Descriptive.geometric_mean([1,2,3]) 
      1.8171205928321397

  """
  def geometric_mean(list) do
    p = List.foldl(list, 1, fn(x, acc) -> acc * x end)
    :math.pow(p, (1/Enum.count(list)))
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

  @doc """
  Computes the skewness of a data set.

  For normally distributed data, the skewness should be about 0. A skewness
  value > 0 means that there is more weight in the left tail of the
  distribution.

  ## Examples 

      iex> Statistics.Descriptive.skew([1,2,3,2,1])  
      0.3436215967445454

  """
  def skew(list) do
    m2 = moment(list, 2)
    m3 = moment(list, 3)
    m3 / :math.pow(m2, 1.5)
  end

  @doc """
  Computes the kurtosis (Fisher) of a list.

  Kurtosis is the fourth central moment divided by the square of the variance.

  ## Examples

      iex> Statistics.Descriptive.kurtosis([1,2,3,2,1]) 
      -1.1530612244897964
    
  """
  def kurtosis(list) do
    m2 = moment(list, 2)
    m4 = moment(list, 4)
    p = m4 / :math.pow(m2, 2.0) # pearson 
    p - 3                       # fisher
  end

end

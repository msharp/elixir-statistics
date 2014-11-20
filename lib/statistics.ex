defmodule Statistics do
  use Application

  alias Statistics.Math

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Statistics.Supervisor.start_link
  end

  @moduledoc """
  Provides basic statistics functions
  """
  
  @doc """
  Sum the contents of a list

  Calls Enum.sum/1
  """
  def sum(list) do
    Enum.sum(list)
  end

  @doc """
  Calculate the mean from a list of numbers

  ## Examples
    
      iex> Statistics.mean([1,2,3])
      2.0

  """
  def mean(list) do
    Enum.sum(list) / Enum.count(list)
  end

  @doc """
  Get the median value from a list

  ## Examples
  
      iex> Statistics.median([1,2,3])
      2
      iex> Statistics.median([1,2,3,4])
      2.5

  """
  def median(list) do
    sorted = Enum.sort(list)
    middle = (Enum.count(list) - 1) / 2
    f_middle = Float.floor(middle) |> Kernel.trunc
    {:ok, m1} = Enum.fetch(sorted, f_middle)
    if middle > f_middle do
      {:ok, m2} = Enum.fetch(sorted, f_middle+1)
      mean([m1,m2])
    else
      m1
    end
  end

  @doc """
  Get the most frequently occuring value
  
  ## Examples

      iex> Statistics.mode([1,2,3,2,4,5,2,6,7,2,8,9]) 
      2

  """
  def mode(list) do
    mode(list, {0, 0})
  end
  defp mode([], champ) do
    {val, _} = champ
    val
  end
  defp mode([h|t], champ) do
    {count, list} = mode_count_and_remove(h, t)
    {_, champ_count} = champ
    {_, new_count} = count
    if new_count > champ_count do
      champ = count
    end
    mode(list, champ)
  end
  defp mode_count_and_remove(val, list) do
    {count, new_list} = mode_count_and_remove(val, 1, list, [])
    {{val,count}, new_list}
  end
  defp mode_count_and_remove(h, count, [h|t], new_list) do
    mode_count_and_remove(h, count+1, t, new_list)
  end
  defp mode_count_and_remove(val, count, [h|t], new_list) do
    mode_count_and_remove(val, count, t, [h|new_list])
  end
  defp mode_count_and_remove(_, count, [], new_list) do
    {count, new_list}
  end

  @doc """
  Get the minimum value from a list

  Call to Enum.min/1
  """
  def min(list) do
    Enum.min(list)
  end

  @doc """
  Get the maximum value from a list

  Call to Enum.max/1
  """
  def max(list) do
    Enum.max(list)
  end

  @doc """
  Get the quartile cutoff value from a list

  responds to only first and third quartile.

  ## Examples

      iex>  Statistics.quartile([1,2,3,4,5,6,7,8,9],:first) 
      3
      iex>  Statistics.quartile([1,2,3,4,5,6,7,8,9],:third)
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
  
      iex> Statistics.percentile([1,2,3,4,5,6,7,8,9],80)
      7.4
      iex> Statistics.percentile([1,2,3,4,5,6,7,8,9],100)
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
        f_rank = Float.floor(rank) |> Kernel.trunc
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
  Calculate variance from a list of numbers

  ## Examples

      iex> Statistics.variance([1,2,3,4])
      1.25
      iex> Statistics.variance([55,56,60,65,54,51,39])
      56.48979591836735

  """
  def variance(list) do
    mean = mean(list)
    squared_diffs = Enum.map(list, fn(x) -> (mean - x) * (mean - x) end)
    sum(squared_diffs) / Enum.count(list)
  end

  @doc """
  Calculate the standard deviation of a list

  ## Examples

      iex> Statistics.stdev([1,2])
      0.5

  """
  def stdev(list) do
    variance(list) |> Math.sqrt
  end

  @doc """
  Calculate the trimmed mean of a list. 
  Can specify cutoff values as a tuple, 
  or simply choose the IQR min/max as the cutoffs

  ## Examples
  
    iex> Statistics.trimmed_mean([1,2,3],{1,3})
    2.0
    iex> Statistics.trimmed_mean([1,2,3,4,5,5,6,6,7,7,8,8,10,11,12,13,14,15], :iqr)
    7.3

  """
  def trimmed_mean(list, {low,high}) do
    Enum.reject(list, fn(x) -> x < low or x > high end)
    |> mean
  end
  def trimmed_mean(list, :iqr) do
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
  
      iex> Statistics.harmonic_mean([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]) 
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

      iex> Statistics.geometric_mean([1,2,3]) 
      1.8171205928321397

  """
  def geometric_mean(list) do
    List.foldl(list, 1, fn(x, acc) -> acc * x end)
    |> Math.pow((1/Enum.count(list)))
  end

  @doc  """
  Calculates the nth moment about the mean for a sample.

  Generally used to calculate coefficients of skewness and  kurtosis.
  Returns the n-th central moment as a float
  The denominator for the moment calculation is the number of
  observations, no degrees of freedom correction is done.

  ## Examples

      iex> Statistics.moment([1,2,3,4,5,6,7,8,9,8,7,6,5,4,3],3) 
      -1.3440000000000025

  """
  def moment(list, moment \\ 1) do
    if moment == 1 do 
      # By definition the first moment about the mean is 0.
      0.0
    else
      mn = mean(list)
      Enum.map(list, fn(x) -> Math.pow((x - mn), moment) end)
      |> mean
    end
  end

  @doc """
  Computes the skewness of a data set.

  For normally distributed data, the skewness should be about 0. A skewness
  value > 0 means that there is more weight in the left tail of the
  distribution.

  ## Examples 

      iex> Statistics.skew([1,2,3,2,1])  
      0.3436215967445454

  """
  def skew(list) do
    m2 = moment(list, 2)
    m3 = moment(list, 3)
    m3 / Math.pow(m2, 1.5)
  end

  @doc """
  Computes the kurtosis (Fisher) of a list.

  Kurtosis is the fourth central moment divided by the square of the variance.

  ## Examples

      iex> Statistics.kurtosis([1,2,3,2,1]) 
      -1.1530612244897964
    
  """
  def kurtosis(list) do
    m2 = moment(list, 2)
    m4 = moment(list, 4)
    p = m4 / Math.pow(m2, 2.0) # pearson 
    p - 3                 # fisher
  end

  @doc """
  Calculate a standard `z` score for each item in a list

  ## Examples

      iex> Statistics.zscore([3,2,3,4,5,6,5,4,3])
      [-0.7427813527082074, -1.5784103745049407, -0.7427813527082074,
      0.09284766908852597, 0.9284766908852594, 1.7641057126819928,
      0.9284766908852594, 0.09284766908852597, -0.7427813527082074]

  """
  def zscore(list) do
    mean = mean(list)
    stdev = stdev(list)
    for n <- list, do: (n-mean)/stdev
  end

  ## helpers and other flotsam
  
  # Split a list into two equal lists.
  # Needed for getting the quartiles.
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

end

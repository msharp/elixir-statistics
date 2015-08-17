defmodule Statistics do
  alias Statistics.Math

  @moduledoc """
  Descriptive statistics functions
  """

  @doc """
  Sum the contents of a list

  Calls Enum.sum/1
  """
  def sum([]), do: nil
  def sum(list), do: sum(list, 0)
  def sum([x|xs], sum), do: sum(xs, sum + x)
  def sum([], sum), do: sum

  @doc """
  Calculate the mean from a list of numbers

  ## Examples

      iex> Statistics.mean([])
      nil

      iex> Statistics.mean([1,2,3])
      2.0

  """
  def mean([]), do: nil
  def mean(list), do: mean(list, 0, 0)
  def mean([x|xs], length, sum) do
    mean(xs, length + 1, sum + x)
  end
  def mean([], length, sum) do
    sum / length
  end

  @doc """
  Get the median value from a list

  ## Examples

      iex> Statistics.median([1,2,3])
      2
      iex> Statistics.median([1,2,3,4])
      2.5

  """
  def median([]), do: nil
  def median(list) when is_list(list) do
    sorted = Enum.sort(list)
    middle = (length(list) - 1) / 2
    f_middle = middle |> Float.floor |> Kernel.trunc
    if middle > f_middle do
      mean Enum.slice(sorted, f_middle, 2)
    else
      Enum.at(sorted, f_middle)
    end
  end

  @doc """
  Get the most frequently occuring value

  ## Examples

      iex> Statistics.mode([1,2,3,2,4,5,2,6,7,2,8,9])
      2

  """
  def mode([]), do: nil
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
  def min([]), do: nil
  def min(list) do
    Enum.min(list)
  end

  @doc """
  Get the maximum value from a list

  Call to Enum.max/1
  """
  def max([]), do: nil
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
  def quartile(list, :first) do
    list |> split_list |> elem(0) |> median
  end
  def quartile(list, :third) do
    list |> split_list |> elem(1) |> median
  end

  @doc """
  Get the nth percentile cutoff from a list

  ## Examples

      iex> Statistics.percentile([1,2,3,4,5,6,7,8,9],80)
      7.4
      iex> Statistics.percentile([1,2,3,4,5,6,7,8,9],100)
      9

  """
  def percentile([], _), do: nil
  def percentile(list, 0), do: Enum.min(list)
  def percentile(list, 100), do: Enum.max(list)
  def percentile(list, n) when is_list(list) and is_number(n) do
    l = Enum.sort(list)
    rank = n / 100.0 * (length(list)-1)
    f_rank = Float.floor(rank) |> Kernel.trunc
    {:ok,lower} = Enum.fetch(l,f_rank)
    {:ok,upper} = Enum.fetch(l,f_rank+1)
    lower + (upper - lower) * (rank - f_rank)
  end

  @doc """
  Get range of data

  ## Examples

      iex> Statistics.range([1,2,3,4,5,6])
      5

  """
  def range([]), do: nil
  def range(list) when is_list(list) do
    max(list) - min(list)
  end

  @doc """
  Calculate the inter-quartile range

  ## Examples

      iex> Statistics.iqr([1,2,3,4,5,6,7,8,9])
      4

  """
  def iqr([]), do: nil
  def iqr(list) when is_list(list) do
    {first_half, second_half} = split_list(list)
    median(second_half) - median(first_half)
  end

  @doc """
  Calculate variance from a list of numbers

  ## Examples

      iex> Statistics.variance([1,2,3,4])
      1.25
      iex> Statistics.variance([55,56,60,65,54,51,39])
      56.48979591836735

  """
  def variance([]), do: nil
  def variance(list) do
    lmean = mean(list)
    list |> Enum.map(fn x -> (lmean - x) * (lmean - x) end) |> mean
  end

  @doc """
  Calculate the standard deviation of a list

  ## Examples

      iex> Statistics.stdev([1,2])
      0.5

  """
  def stdev([]), do: nil
  def stdev(list) do
    variance(list) |> Math.sqrt
  end

  @doc """
  Calculate the trimmed mean of a list.

  Can specify cutoff values as a tuple, or simply choose the IQR min/max as the cutoffs

  ## Examples

      iex> Statistics.trimmed_mean([1,2,3], {1,3})
      2.0
      iex> Statistics.trimmed_mean([1,2,3,4,5,5,6,6,7,7,8,8,10,11,12,13,14,15], :iqr)
      7.3

  """
  def trimmed_mean(list, cutoff) when cutoff == :iqr do
    {first_half, second_half} = split_list(list)
    trimmed_mean(list, {median(first_half), median(second_half)})
  end
  def trimmed_mean(list, cutoff) when is_tuple(cutoff) do
    {low, high} = cutoff
    list |> Enum.reject(fn x -> x < low or x > high end) |> mean
  end

  @doc """
  Calculates the harmonic mean from a list

  Harmonic mean is the number of values divided by
  the sum of the reciprocal of all the values.

  ## Examples

      iex> Statistics.harmonic_mean([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])
      4.5204836768674568

  """
  def harmonic_mean([]), do: nil
  def harmonic_mean(list) when is_list(list) do
    {sum, count} = List.foldl list, {0, 0}, fn x, {sum, count} ->
      {sum + 1 / x, count + 1}
    end
    count / sum
  end

  @doc """
  Calculate the geometric mean of a list

  Geometric mean is the nth root of the product of n values

  ## Examples

      iex> Statistics.geometric_mean([1,2,3])
      1.8171205928321397

  """
  def geometric_mean([]), do: nil
  def geometric_mean(list) do
    List.foldl(list, 1, fn x, acc -> acc * x end)
    |> Math.pow(1 / length(list))
  end

  @doc """
  Calculates the nth moment about the mean for a sample.

  Generally used to calculate coefficients of skewness and  kurtosis.
  Returns the n-th central moment as a float
  The denominator for the moment calculation is the number of
  observations, no degrees of freedom correction is done.

  ## Examples

      iex> Statistics.moment([1,2,3,4,5,6,7,8,9,8,7,6,5,4,3],3)
      -1.3440000000000025

  """
  def moment(list, n \\ 1)
  # By definition the first moment about the mean is 0.
  def moment(list, 1), do: 0.0
  # Otherwise
  def moment(list, n) when is_number(n) do
    mn = mean(list)
    list |> Enum.map(fn x -> Math.pow((x - mn), n) end) |> mean
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
    for n <- list, do: (n - mean)/stdev
  end

  @doc """
  Calculate the the Pearson product-moment correlation coefficient of two lists.

  The two lists are presumed to represent matched pairs of observations, the `x` and `y` of a simple regression.

  ## Examples

      iex> Statistics.correlation([1,2,3,4], [1,3,5,6])
      0.9897782665572894

  """
  def correlation(x, y) when length(x) != length(y) do
    raise ArgumentError, "Lists must be equal length"
  end

  def correlation(x, y) do
    mu_x = mean(x)
    mu_y = mean(y)
    numer = Enum.zip(x, y)
            |> Enum.map(fn {xi, yi} -> (xi - mu_x) * (yi - mu_y) end)
            |> Enum.sum
    denom_x = x
              |> Enum.map(fn xi -> Math.pow((xi - mu_x), 2) end)
              |> Enum.sum
    denom_y = y
              |> Enum.map(fn yi -> Math.pow((yi - mu_y), 2) end)
              |> Enum.sum

    numer / Math.sqrt(denom_x * denom_y)
  end

  @doc """
  Calculate the covariance of two lists.

  Covariance is a measure of how much two random variables change together.
  The two lists are presumed to represent matched pairs of observations, such as the `x` and `y` of a simple regression.

  ## Examples

      iex> Statistics.covariance([1,2,3,2,1], [1,4,5.2,7,99])
      -17.89

  """
  def covariance(x, y) when length(y) != length(x) do
    raise ArgumentError, "Lists must be equal length"
  end

  def covariance(x, y) do
    mu_x = mean(x)
    mu_y = mean(y)
    Enum.zip(x, y)
    |> Enum.map(fn {xi, yi} -> (xi - mu_x) * (yi - mu_y) end)
    |> Enum.map(fn i -> i / (Enum.count(x) - 1) end)
    |> Enum.sum
  end


  ## helpers and other flotsam

  # Split a list into two equal lists.
  # Needed for getting the quartiles.
  import Integer, only: [is_even: 1, is_odd: 1]

  def split_list(list) when is_list(list), do: split_list(list, length(list))
  def split_list(list, size) when is_even(size) do
    middle = trunc(size / 2)
    do_split_list(list, middle, middle)
  end
  def split_list(list, size) when is_odd(size) do
    middle = trunc((size + 1) / 2)
    do_split_list(list, middle, middle - 1)
  end

  defp do_split_list(list, take, drop) when is_integer(take) and is_integer(drop) do
    list = Enum.sort(list)
    {Enum.take(list, take), Enum.drop(list, drop)}
  end
end

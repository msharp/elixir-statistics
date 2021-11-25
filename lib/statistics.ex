defmodule Statistics do
  alias Statistics.Math

  @moduledoc """
  Descriptive statistics functions
  """

  @doc """
  Sum the contents of a list

  Calls Enum.sum/1
  """
  @spec sum([number]) :: number
  def sum(list) when is_list(list), do: do_sum(list, 0)

  defp do_sum([], t), do: t
  defp do_sum([x | xs], t), do: do_sum(xs, t + x)

  @doc """
  Calculate the mean from a list of numbers

  ## Examples

      iex> Statistics.mean([])
      nil
      iex> Statistics.mean([1,2,3])
      2.0

  """
  @spec mean([number]) :: float() | nil
  def mean(list) when is_list(list), do: do_mean(list, 0, 0)

  defp do_mean([], 0, 0), do: nil
  defp do_mean([], t, l), do: t / l

  defp do_mean([x | xs], t, l) do
    do_mean(xs, t + x, l + 1)
  end

  @doc """
  Get the median value from a list.

  ## Examples

      iex> Statistics.median([])
      nil
      iex> Statistics.median([1,2,3])
      2
      iex> Statistics.median([1,2,3,4])
      2.5

  """
  @spec median([number]) :: number | nil
  def median([]), do: nil

  def median(list) when is_list(list) do
    midpoint =
      (length(list) / 2)
      |> Float.floor()
      |> round

    {l1, l2} =
      Enum.sort(list)
      |> Enum.split(midpoint)

    case length(l2) > length(l1) do
      true ->
        [med | _] = l2
        med

      false ->
        [m1 | _] = l2
        [m2 | _] = Enum.reverse(l1)
        mean([m1, m2])
    end
  end

  @doc """
  Get the most frequently occuring value

  ## Examples

      iex> Statistics.mode([])
      nil
      iex> Statistics.mode([1,2,3,2,4,5,2,6,7,2,8,9])
      2

  """
  @spec mode([number]) :: number | nil
  def mode([]), do: nil

  def mode(list) when is_list(list) do
    h = hist(list)
    max = Map.values(h) |> Enum.max()
    h |> Enum.find(fn {_, val} -> val == max end) |> elem(0)
  end

  @doc """
  Get a frequency count of the values in a list

  ## Examples

      iex> Statistics.hist([])
      nil
      iex> Statistics.hist([1,2,3,2,4,5,2,5,1,2,5,5])
      %{1 => 2, 2 => 4, 3 => 1, 4 => 1, 5 => 4}

  """
  @spec hist([number]) :: map | nil
  def hist([]), do: nil

  def hist(list) when is_list(list) do
    list
    |> Enum.reduce(%{}, fn tag, acc -> Map.update(acc, tag, 1, &(&1 + 1)) end)
  end

  @doc """
  Get the minimum value from a list

      iex> Statistics.min([])
      nil
      iex> Statistics.min([1,2,3])
      1

  If a non-empty list is provided, it is a call to Enum.min/1
  """
  @spec min([number]) :: number | nil
  def min([]), do: nil

  def min(list) do
    Enum.min(list)
  end

  @doc """
  Get the maximum value from a list

      iex> Statistics.max([])
      nil
      iex> Statistics.max([1,2,3])
      3

  If a non-empty list is provided, it is a call to Enum.max/1
  """
  @spec max([number]) :: number |nil
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
  # TODO change these to call `percentile/2`
  @spec quartile([number], :first | :third) :: number
  def quartile(list, :first) do
    list |> split |> elem(0) |> median
  end

  def quartile(list, :third) do
    list |> split |> elem(1) |> median
  end

  @doc """
  Get the nth percentile cutoff from a list

  ## Examples

      iex> Statistics.percentile([], 50)
      nil
      iex> Statistics.percentile([1], 50)
      1
      iex> Statistics.percentile([1,2,3,4,5,6,7,8,9],80)
      7.4
      iex> Statistics.percentile([1,2,3,4,5,6,7,8,9],100)
      9

  """
  @spec percentile([number], number) :: number | nil
  def percentile([], _), do: nil
  def percentile([x], _), do: x
  def percentile(list, 0), do: min(list)
  def percentile(list, 100), do: max(list)

  def percentile(list, n) when is_list(list) and is_number(n) do
    s = Enum.sort(list)
    r = n / 100.0 * (length(list) - 1)
    f = :erlang.trunc(r)
    lower = Enum.at(s, f)
    upper = Enum.at(s, f + 1)
    lower + (upper - lower) * (r - f)
  end

  @doc """
  Get range of data

  ## Examples

      iex> Statistics.range([1,2,3,4,5,6])
      5

  """
  @spec range([number]) :: number | nil
  def range([]), do: nil

  def range(list) when is_list(list) do
    max(list) - min(list)
  end

  @doc """
  Calculate the inter-quartile range

  ## Examples

      iex> Statistics.iqr([])
      nil
      iex> Statistics.iqr([1,2,3,4,5,6,7,8,9])
      4

  """
  @spec iqr([number]) :: number | nil
  def iqr([]), do: nil

  def iqr(list) when is_list(list) do
    {first, second} = split(list)
    median(second) - median(first)
  end

  @doc """
  Calculate variance from a list of numbers

  ## Examples

      iex> Statistics.variance([])
      nil
      iex> Statistics.variance([1,2,3,4])
      1.25
      iex> Statistics.variance([55,56,60,65,54,51,39])
      56.48979591836735

  """
  @spec variance([number]) :: number | nil
  def variance([]), do: nil

  def variance(list) when is_list(list) do
    list_mean = mean(list)
    list |> Enum.map(fn x -> (list_mean - x) * (list_mean - x) end) |> mean
  end

  @doc """
  Calculate the standard deviation of a list

  ## Examples

      iex> Statistics.stdev([])
      nil
      iex> Statistics.stdev([1,2])
      0.5

  """
  @spec stdev([number]) :: number | nil
  def stdev([]), do: nil

  def stdev(list) do
    list |> variance |> Math.sqrt()
  end

  @doc """
  Calculate the trimmed mean of a list.

  Can specify cutoff values as a tuple, or simply choose the IQR min/max as the cutoffs

  ## Examples

      iex> Statistics.trimmed_mean([], :iqr)
      nil
      iex> Statistics.trimmed_mean([1,2,3], {1,3})
      2.0
      iex> Statistics.trimmed_mean([1,2,3,4,5,5,6,6,7,7,8,8,10,11,12,13,14,15], :iqr)
      7.3

  """
  @spec trimmed_mean([number], atom | tuple) :: number | nil
  def trimmed_mean([], _), do: nil

  def trimmed_mean(list, :iqr) do
    {first, second} = split(list)
    trimmed_mean(list, {median(first), median(second)})
  end

  def trimmed_mean(list, {low, high}) do
    list |> Enum.reject(fn x -> x < low or x > high end) |> mean
  end

  @doc """
  Calculates the harmonic mean from a list

  Harmonic mean is the number of values divided by
  the sum of the reciprocal of all the values.

  ## Examples

      iex> Statistics.harmonic_mean([])
      nil
      iex> Statistics.harmonic_mean([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])
      4.5204836768674568

  """
  @spec harmonic_mean([number]) :: number | nil
  def harmonic_mean([]), do: nil

  def harmonic_mean(list) when is_list(list) do
    do_harmonic_mean(list, 0, 0)
  end

  defp do_harmonic_mean([], t, l), do: l / t

  defp do_harmonic_mean([x | xs], t, l) do
    do_harmonic_mean(xs, t + 1 / x, l + 1)
  end

  @doc """
  Calculate the geometric mean of a list

  Geometric mean is the nth root of the product of n values

  ## Examples

      iex> Statistics.geometric_mean([])
      nil
      iex> Statistics.geometric_mean([1,2,3])
      1.8171205928321397

  """
  @spec geometric_mean([number]) :: number | nil
  def geometric_mean([]), do: nil

  def geometric_mean(list) when is_list(list) do
    do_geometric_mean(list, 1, 0)
  end

  defp do_geometric_mean([], p, l), do: Math.pow(p, 1 / l)

  defp do_geometric_mean([x | xs], p, l) do
    do_geometric_mean(xs, p * x, l + 1)
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
      iex> Statistics.moment([], 2)
      nil

  """
  @spec moment([number], pos_integer) :: number | nil
  def moment(list, n \\ 1)
  # empty list has no moment
  def moment([], _), do: nil
  # By definition the first moment about the mean is 0.
  def moment(_, 1), do: 0.0
  # Otherwise
  def moment(list, n) when is_list(list) and is_number(n) do
    lmean = mean(list)
    list |> Enum.map(&Math.pow(&1 - lmean, n)) |> mean
  end

  @doc """
  Computes the skewness of a data set.

  For normally distributed data, the skewness should be about 0. A skewness
  value > 0 means that there is more weight in the left tail of the
  distribution.

  ## Examples

      iex> Statistics.skew([])
      nil
      iex> Statistics.skew([1,2,3,2,1])
      0.3436215967445454

  """
  @spec skew([number]) :: number | nil
  def skew([]), do: nil

  def skew(list) do
    m2 = moment(list, 2)
    m3 = moment(list, 3)
    m3 / Math.pow(m2, 1.5)
  end

  @doc """
  Computes the kurtosis (Fisher) of a list.

  Kurtosis is the fourth central moment divided by the square of the variance.

  ## Examples

      iex> Statistics.kurtosis([])
      nil
      iex> Statistics.kurtosis([1,2,3,2,1])
      -1.1530612244897964

  """
  @spec kurtosis([number]) :: number | nil
  def kurtosis([]), do: nil

  def kurtosis(list) do
    m2 = moment(list, 2)
    m4 = moment(list, 4)
    # pearson
    p = m4 / Math.pow(m2, 2.0)
    # fisher
    p - 3
  end

  @doc """
  Calculate a standard `z` score for each item in a list

  ## Examples

      iex> Statistics.zscore([3,2,3,4,5,6,5,4,3])
      [-0.7427813527082074, -1.5784103745049407, -0.7427813527082074,
      0.09284766908852597, 0.9284766908852594, 1.7641057126819928,
      0.9284766908852594, 0.09284766908852597, -0.7427813527082074]

  """
  @spec zscore([number]) :: list | nil
  def zscore(list) when is_list(list) do
    lmean = mean(list)
    lstdev = stdev(list)
    for n <- list, do: (n - lmean) / lstdev
  end

  @doc """
  Calculate the the Pearson product-moment correlation coefficient of two lists.

  The two lists are presumed to represent matched pairs of observations, the `x` and `y` of a simple regression.

  ## Examples

      iex> Statistics.correlation([1,2,3,4], [1,3,5,6])
      0.9897782665572894

  """
  @spec correlation([number], [number]) :: number
  def correlation(x, y) when length(x) == length(y) do
    xmean = mean(x)
    ymean = mean(y)

    numer =
      Enum.zip(x, y)
      |> Enum.map(fn {xi, yi} -> (xi - xmean) * (yi - ymean) end)
      |> sum

    denom_x =
      x
      |> Enum.map(fn xi -> (xi - xmean) * (xi - xmean) end)
      |> sum

    denom_y =
      y
      |> Enum.map(fn yi -> (yi - ymean) * (yi - ymean) end)
      |> sum

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
  @spec covariance([number], [number]) :: number
  def covariance(x, y) when length(x) == length(y) do
    xmean = mean(x)
    ymean = mean(y)
    size = length(x)

    Enum.zip(x, y)
    |> Enum.map(fn {xi, yi} -> (xi - xmean) * (yi - ymean) end)
    |> Enum.map(fn i -> i / (size - 1) end)
    |> sum
  end

  ## helpers and other flotsam

  import Integer, only: [is_even: 1, is_odd: 1]

  # Split a list into two equal lists.
  # Needed for getting the quartiles.
  defp split(list) when is_list(list) do
    do_split(Enum.sort(list), length(list))
  end

  defp do_split(sorted_list, l) when is_even(l) do
    m = :erlang.trunc(l / 2)
    {Enum.take(sorted_list, m), Enum.drop(sorted_list, m)}
  end

  defp do_split(sorted_list, l) when is_odd(l) do
    m = :erlang.trunc((l + 1) / 2)
    {Enum.take(sorted_list, m), Enum.drop(sorted_list, m - 1)}
  end
end

defmodule Statistics.Distributions.Poisson do
  @moduledoc """
  The Poisson distribution is a discrete probablility distribution.

  It models the probability of a given number of events occurring
  in a fixed interval if the events occur with a known average rate
  and are independent of the previous event.

  """

  alias Statistics.Math

  @doc """
  Probability mass function

  ## Examples

      iex> Statistics.Distributions.Poisson.pmf(1).(1)
      0.36787944117144233

  """
  @spec pmf(number) :: fun
  def pmf(lambda) do
    fn k ->
      Math.pow(lambda, k) / Math.factorial(k) * Math.exp(-lambda)
    end
  end

  @doc """
  Get the probability that a value lies below `k`

  ## Examples

    iex> Statistics.Distributions.Poisson.cdf(1).(1)
    0.73575888234288467

  """
  @spec cdf(number) :: fun
  def cdf(lambda) do
    fn k ->
      s =
        Enum.map(0..Math.to_int(k), fn x -> Math.pow(lambda, x) / Math.factorial(x) end)
        |> Enum.sum()

      Math.exp(-lambda) * s
    end
  end

  @doc """
  The percentile-point function

  Get the maximum point which lies below the given probability.
  This is the inverse of the cdf and will take only positive integer values
  (but returns a float)

  ## Examples

      iex> Statistics.Distributions.Poisson.ppf(1).(0.95)
      3.0

  """
  @spec ppf(number) :: fun
  def ppf(lambda) do
    fn x ->
      ppf_tande(x, lambda, 0.0)
    end
  end

  # the trusty trial-and-error method
  defp ppf_tande(x, lambda, guess) do
    if x > cdf(lambda).(guess) do
      ppf_tande(x, lambda, guess + 1)
    else
      guess
    end
  end

  @doc """
  Draw a random number from this distribution

  This is a discrete distribution and the values it can take are positive integers.

  ## Examples

      iex> Statistics.Distributions.Poisson.rand(1)
      1.0

  """
  @spec rand(number) :: number
  def rand(lambda) do
    x = (Math.rand() * 100 + lambda) |> Math.floor()

    if pmf(lambda).(x) > Math.rand() do
      x
    else
      # keep trying
      rand(lambda)
    end
  end
end

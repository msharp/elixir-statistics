defmodule Statistics.Distributions.Exponential do
  @moduledoc """
  Exponential distribution.

  `lambda` is the rate parameter and must be greater than zero.
  """

  alias Statistics.Math

  @doc """
  The probability density function

  ## Examples

      iex> Statistics.Distributions.Exponential.pdf(1, 1)
      0.36787944117144233

  """
  def pdf(x) do
    pdf(x, 1)
  end
  def pdf(x, _) when x < 0 do
    0
  end
  def pdf(_, lambda) when lambda <= 0 do
    :nan
  end
  def pdf(x, lambda) do
    lambda * Math.exp(-lambda*x)
  end

  @doc """
  The cumulative density function

  ## Examples

      iex> Statistics.Distributions.Exponential.cdf(1, 1)
      0.6321205588285577

  """
  def cdf(x) do
    cdf(x, 1)
  end
  def cdf(x, _) when x < 0 do
    0
  end
  def cdf(_, lambda) when lambda <= 0 do
    :nan
  end
  def cdf(x, lambda) do
    1 - Math.exp(-lambda*x)
  end

  @doc """
  The percentile-point function

  ## Examples

      iex> Statistics.Distributions.Exponential.ppf(0.1)
      0.10536051565782628

  """
  def ppf(x) do
    ppf(x, 1)
  end
  def ppf(x, _) when x == 1 do
    :inf
  end
  def ppf(x, lambda) when x < 0 or x > 1 or lambda < 0 do
    :nan
  end
  def ppf(x, lambda) do
    -1 * Math.ln(1-x) / lambda
  end

  @doc """
  Draw a random number from the distribution with specified lambda

  Uses the [rejection sampling method](https://en.wikipedia.org/wiki/Rejection_sampling)

  ## Examples

      iex> Statistics.Distributions.Exponential.rand(1)
      0.145709384787

  """
  def rand(lambda) do
    x = Math.rand() * lambda * 100
    if pdf(x, lambda) > Math.rand() do
      x
    else
      rand(lambda) # keep trying
    end
  end

end

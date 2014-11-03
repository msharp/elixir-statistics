defmodule Statistics.Distributions.Chisq do

  alias Statistics.MathHelpers, as: Math

  @moduledoc """
  Chi square distribution.

   *degrees of freedom* parameter.
  """

  @doc """
  The probability density function

  ## Examples

      iex> Statistics.Distributions.Chisq.pdf(2, 1)
      0.10377687435514865

  """
  def pdf(x, df) do
    1 / (Math.pow(2, df/2) * Math.gamma(df/2)) * Math.pow(x, (df/2-1)) * Math.exp(-1*x/2)
  end
  def pdf(x) do
    pdf(x, 1)
  end

  @doc """
  The cumulative density function

  ## Examples

      iex> Statistics.Distributions.Chisq.cdf(2, 2)
      0.6321205588285574

  """
  def cdf(x, df) do
    g = Math.gamma(df/2.0) 
    b = Math.gammainc(df/2.0, x/2.0)
    b / g  
  end

  @doc """
  The percentile-point function
  """
  def ppf(x) do
    0.0
  end

  @doc """
  Draw a random number from a t distribution with specified degrees of freedom

  Uses the [rejection sampling method](https://en.wikipedia.org/wiki/Rejection_sampling)

  ## Examples

      iex> Statistics.Distributions.Chisq.rand(2)
      1.232433646523534767

  """
  def rand(df) do
    x = Math.rand() * 100
    if pdf(x, df) > Math.rand() do
      x
    else
      rand(df) # keep trying
    end
  end

  ######################################################
  ######################################################
  ######################################################

end


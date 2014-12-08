defmodule Statistics.Distributions.Chisq do

  alias Statistics.Math
  alias Statistics.Math.Functions

  @moduledoc """
  Chi square distribution.

   *degrees of freedom* parameter.
  """

  @doc """
  The probability density function

  ## Examples

      iex> Statistics.Distributions.Chisq.pdf(2, 1)
      0.10377687435514868

  """
  def pdf(x, df) do
    1 / (Math.pow(2, df/2) * Functions.gamma(df/2)) * Math.pow(x, (df/2-1)) * Math.exp(-1*x/2)
  end

  @doc """
  The cumulative density function

  ## Examples

      iex> Statistics.Distributions.Chisq.cdf(2, 2)
      0.6321205588285578

  """
  def cdf(x, df) do
    g = Functions.gamma(df/2.0) 
    b = Functions.gammainc(df/2.0, x/2.0)
    b / g  
  end

  @doc """
  The percentile-point function

  ## Examples 

      iex> Statistics.Distributions.Chisq.ppf(0.95, 1)
      3.841458820694101

  """
  def ppf(x, df) do
    ppf_tande(x, df) 
  end
  # trial-and-error method which refines guesses
  # to arbitrary number of decimal places 
  defp ppf_tande(x, df, precision \\ 14) do
    ppf_tande(x, df, 0, precision+2, 0) 
  end
  defp ppf_tande(_, _, g, precision, precision) do
    g
  end
  defp ppf_tande(x, df, g, precision, p) do
    increment = 100 / Math.pow(10, p)
    guess = g + increment
    if x < cdf(guess, df) do
      ppf_tande(x, df, g, precision, p+1)
    else
      ppf_tande(x, df, guess, precision, p)
    end
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

end


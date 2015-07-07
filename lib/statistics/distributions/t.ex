defmodule Statistics.Distributions.T do

  alias Statistics.Math
  alias Statistics.Math.Functions

  @moduledoc """
  Student's t distribution.

  This distribution is always centered around 0.0 and allows a *degrees of freedom* parameter.
  """

  @doc """
  The probability density function

  ## Examples

      iex> Statistics.Distributions.T.pdf(0, 3)
      0.3675525969478612
      iex> Statistics.Distributions.T.pdf(3.2, 1)
      0.028319384891796327

  """
  def pdf(x, df) do
    Functions.gamma((df+1)/2) / (Math.sqrt(df*Math.pi) * Functions.gamma(df/2) ) * Math.pow((1 + (x*x/df)), ((df+1)/2)*-1)
  end

  @doc """
  The cumulative density function

  ## Examples

      iex> Statistics.Distributions.T.cdf(0, 3)
      0.4909182507070275
      
  """
  def cdf(x, df) do
    p1 = 0.5 + x * Functions.gamma((df+1)/2)
    hyp_b = (df+1)/2 
    hyp_x = -1 * Math.pow(x, 2)/df
    p2n = Functions.hyp2f1(0.5, hyp_b, 1.5, hyp_x)
    p2d = Math.sqrt(Math.pi*df) * Functions.gamma(df/2)
    p1 * (p2n / p2d)
  end

  @doc """
  The percentile-point function

  NOTE: this is very slow due to the current implementation of the CDF

  """
  def ppf(x, df) do
    ppf_tande(x, df)
  end
  # trial-and-error method which refines guesses
  # to arbitrary number of decimal places
  defp ppf_tande(x, df, precision \\ 12) do
    ppf_tande(x, df, -10, precision+2, 0)
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
  """
  def rand(df) do
    x = Math.rand() * 50 - 25 # t-dist is fatter-tailed than normal
    if pdf(x, df) > Math.rand() do
      x
    else
      rand(df) # keep trying
    end
  end

end

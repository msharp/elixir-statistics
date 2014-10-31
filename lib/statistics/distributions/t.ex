defmodule Statistics.Distributions.T do

  alias Statistics.MathHelpers, as: Math

  @moduledoc """
  Student's t distribution.

  This distribution is always centered around 0.0 and allows a *degrees of freedom* parameter.
  """

  @doc """
  The probability density function

  ## Examples

      iex> Statistics.Distributions.T.pdf(0, 3)
      0.36755259694786124
      iex> Statistics.Distributions.T.pdf(3.2)
      0.02831938489179633

  """
  def pdf(x, df) do
    Math.gamma((df+1)/2) / (Math.sqrt(df*Math.pi) * Math.gamma(df/2) ) * Math.pow((1 + (x*x/df)), ((df+1)/2)*-1)
  end
  def pdf(x) do
    pdf(x, 1)
  end

  @doc """
  The cumulative density function
  """
  def cdf(x) do
    0.0
  end

  @doc """
  The percentile-point function
  """
  def ppf(x) do
    0.0
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




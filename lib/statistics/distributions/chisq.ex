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
    1 / (Math.pow(2, df/2) * gamma(df/2)) * Math.pow(x, (df/2-1)) * Math.exp(-1*x/2)
  end
  def pdf(x) do
    pdf(x, 1)
  end

  @doc """
  The cumulative density function

  ## Examples

  #iex> Statistics.Distributions.Chisq(2, 2)
  #    0.63212055882855778

  http://rosettacode.org/wiki/Verify_distribution_uniformity/Chi-squared_test

  """
  def cdf(x, df) do
    g = gamma(df/2) 
    b = lgamma(df/2, x/2)
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

  def lgamma(s, x) do
    (s-1)*beta(s-1,x)-Math.pow(s, x-1)*Math.exp(-1*x)
  end

  @doc """
  The Gamma function

  Two implementations available here:

      - Using Taylor series coefficients 
      - using the [Lanczos approximation](http://en.wikipedia.org/wiki/Lanczos_approximation)
  
  """
  def gamma(x) do
    gamma_lanczos(x)
    #gamma_taylor(x)
  end

  defp gamma_lanczos(x) do
    # coefficients used by the GNU Scientific Library
    g = 7
    p = [0.99999999999980993, 676.5203681218851, -1259.1392167224028,
         771.32342877765313, -176.61502916214059, 12.507343278686905,
         -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7]
    # recursive formula
    if x < 0.5 do
      Math.pi / (:math.sin(Math.pi*x) * gamma_lanczos(1-x))
    else
      z = x - 1
      xs = for i <- 1..8, do: Enum.at(p, i)/(z+i)
      x = Enum.at(p, 0) + Enum.sum(xs)
      t = z + g + 0.5
      Math.sqrt(2*Math.pi) * Math.pow(t, (z+0.5)) * Math.exp(-1*t) * x
    end
  end

  @doc """
  The Beta function
  """
  def beta(x, y) do
    # from https://en.wikipedia.org/wiki/Beta_function#Properties
    gamma(x) * gamma(y) / gamma(x + y)
  end

end




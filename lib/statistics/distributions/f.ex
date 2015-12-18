defmodule Statistics.Distributions.F do

  alias Statistics.Math
  alias Statistics.Math.Functions
  alias Statistics.Distributions.Beta

  @moduledoc """
  The F distribution

  Note that `ppf/2` and `rand/2` here are very slow.
  """

  @doc """
  The probability density function

  ## Examples

      iex> Statistics.Distributions.F.pdf(1,1).(1)
      0.15915494309189537

  """
  @spec pdf(number,number) :: fun
  def pdf(d1, d2) do
    fn x ->
      # create components
      a = Math.pow(d1*x, d1) * Math.pow(d2, d2)
      b = Math.pow(d1*x+d2, d1+d2) 
      c = x * Functions.beta(d1/2, d2/2)
      # for the equation
      Math.sqrt(a/b) / c
    end
  end

  @doc """
  The cumulative density function

  ## Examples

      iex> Statistics.Distributions.F.cdf(1,1).(1)
      0.4971668763845647
      
  NOTE this is rather imprecise owing to the use
  of numerical integration of `Beta.pdf/2` to 
  approximate the regularised incomplete beta function
  """
  # NOTE the cdf is defined in terms of 
  # the regularised incomplete Beta function
  # which is the CDF of the Beta distribution
  @spec cdf(number,number) :: fun
  def cdf(d1, d2) do
    fn x ->
      xx = (d1*x) / ((d1*x) + d2)
      Beta.cdf(d1/2, d2/2).(xx)
    end
  end

  @doc """
  The percentile-point function

  ## Examples

      iex> Statistics.Distributions.F.ppf(1,1).(1)
      1.0180414899099999
      
  """
  @spec ppf(number,number) :: fun
  def ppf(d1, d2) do
    fn x ->
      ppf_tande(cdf(d1, d2), x)
    end
  end
  # trial-and-error method which refines guesses
  defp ppf_tande(cdf, x) do
    ppf_tande(cdf, x, 0.0, 14, 0)
  end
  defp ppf_tande(_, _, guess, precision, current_precision) when current_precision >= precision do
    guess
  end
  defp ppf_tande(cdf, x, guess, precision, current_precision) do
    # add 1/10**precision'th of the max value to the min
    new_guess = guess + (100000 / Math.pow(10, current_precision))
    cg = cdf.(new_guess) 
    # if it's less than the PPF we want, do it again
    if cg < x do
      ppf_tande(cdf, x, new_guess, precision, current_precision+0.1)
    else
      # otherwise (it's greater), increase the current_precision
      # and recurse with original guess
      ppf_tande(cdf, x, guess, precision, current_precision+1)
    end
  end

  @doc """
  Draw a random number from an F distribution 
  """
  @spec rand(number,number) :: number
  def rand(d1, d2) do
    ceil = ppf(d1,d2).(0.999)
    do_rand(pdf(d1, d2), ceil)
  end
  defp do_rand(pdf, ceil) do
    x = Math.rand() * ceil
    if pdf.(x) > Math.rand() do
      x
    else
      do_rand(pdf, ceil)  # keep trying
    end
  end

end

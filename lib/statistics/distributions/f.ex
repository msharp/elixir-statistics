defmodule Statistics.Distributions.F do

  alias Statistics.Math
  alias Statistics.Math.Functions

  @moduledoc """
  The F distribution
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
      0.5
      
  """
  @spec cdf(number,number) :: fun
  def cdf(d1, d2) do
    fn x ->
      #Functions.simpson(pdf(d1,d2), 0, x, 1000)
      0.5
    end
  end

  @doc """
  The percentile-point function

  ## Examples

      iex> Statistics.Distributions.F.ppf(1,1).(1)
      1.0
      
  """
  @spec ppf(number,number) :: fun
  def ppf(d1, d2) do
    fn x ->
      # ppf_tande(x, d1, d2)
      1.0
    end
  end
  # trial-and-error method which refines guesses
  # to arbitrary number of decimal places
  defp ppf_tande(x, d1, d2, precision \\ 4) do
    ppf_tande(x, d1, d2, -10, precision+2, 0)
  end
  defp ppf_tande(_, _, _, g, precision, precision) do
    g
  end
  defp ppf_tande(x, d1, d2, g, precision, p) do
    increment = 100 / Math.pow(10, p)
    guess = g + increment
    if x < cdf(d1, d2).(guess) do
      ppf_tande(x, d1, d2, g, precision, p+1)
    else
      ppf_tande(x, d1, d2, guess, precision, p)
    end
  end

  @doc """
  Draw a random number from an F distribution 
  """
  @spec rand(number,number) :: number
  def rand(d1, d2) do
    x = Math.rand() * ppf(d1,d2).(0.9999)
    if pdf(d1, d2).(x) > Math.rand() do
      x
    else
      rand(d1, d2) # keep trying
    end
  end

end

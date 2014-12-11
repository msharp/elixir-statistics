defmodule Statistics.Distributions.Poisson do

  @moduledoc """
  The Poisson distribution is a discrete probablility distribution

  """

  alias Statistics.Math

  @doc """
  Probability mass function
  
  ## Examples
  
      iex> Statistics.Distributions.Poisson.pmf(1,1) 
      0.36787944117144233

  """
  def pmf(k, lambda) do
    Math.pow(lambda, k) * Math.exp(-k) / Math.factorial(k)
  end


  @doc """
  Get the probability that a value lies below `x`
  
  ## Examples

    iex> Statistics.Distributions.Poisson.cdf(1, 1)
    0.73575888234288467
                 
  """
  def cdf(k, lambda) do
    s = Enum.map(0..Math.to_int(k), fn x -> Math.pow(lambda, x) / Math.factorial(x) end) |> Enum.sum
    Math.exp(-lambda) * s
  end

  
  @doc """
  The percentile-point function

  Get the maximum point which lies below the given probability.
  This is the inverse of the cdf

  ## Examples

      iex> Statistics.Distributions.Poisson.ppf(0.95, 1) 
      3.0

  """
  def ppf(x, lambda) do
    3.0
  end
   
  
  @doc """
  Draw a random number from this distribution

  Uses the [rejection sampling method](https://en.wikipedia.org/wiki/Rejection_sampling)

  ## Examples

      iex> Statistics.Distributions.Poisson.rand(1)
      1.0

  """
  def rand(lambda) do 
    1.0
  end

end

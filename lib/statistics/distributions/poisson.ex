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
  
      iex> Statistics.Distributions.Poisson.pmf(1,1) 
      0.36787944117144233

  """
  def pmf(k, lambda) do
    Math.pow(lambda, k) / Math.factorial(k) * Math.exp(-lambda)
  end


  @doc """
  Get the probability that a value lies below `k`
  
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
  This is the inverse of the cdf and will take only positive integer values 
  (but returns a float)

  ## Examples

      iex> Statistics.Distributions.Poisson.ppf(0.95, 1) 
      3.0

  """
  def ppf(x, lambda) do
    ppf_tande(x, lambda, 0.0)
  end
  # the trusty trial-and-error method 
  defp ppf_tande(x, lambda, guess) do
    if x > cdf(guess, lambda) do
      ppf_tande(x, lambda, guess+1)
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
  def rand(lambda) do 
    x = Math.rand() * 100 + lambda |> Math.floor
    if pmf(x, lambda) > Math.rand() do 
      x
    else
      rand(lambda) # keep trying
    end
  end

end

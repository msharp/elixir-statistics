defmodule Statistics.Distributions.Binomial do

  alias Statistics.Math

  @moduledoc """
  Binomial distribution.

  This models the expected outcome of a number
  of binary trials, each with known probability, 
  (often called a Bernoulli trial)
  """

  @doc """
  The probability mass function

  ## Examples

      iex> Statistics.Distributions.Binomial.pmf(4, 0.5).(2)
      0.375

  """
  @spec pmf(non_neg_integer, number) :: fun
  def pmf(n, p) do
    fn k ->
      cond do
        k < 1.0 -> 
          0.0
        n < k ->
          0.0
        true -> 
          xk = Math.to_int(k)
          Math.combination(n, xk) * Math.pow(p, xk) * Math.pow(1-p, n-xk)
      end
    end
  end

  @doc """
  The cumulative density function

  ## Examples

      iex> Statistics.Distributions.Binomial.cdf(4, 0.5).(2)
      0.6875
  
  """
  @spec ppf(non_neg_integer, number) :: fun
  def cdf(n, p) do
    fn k ->
      0..Math.to_int(Math.floor(k))
      |> Enum.to_list
      |> Enum.map(fn i -> Math.combination(n, i) * Math.pow(p, i) * Math.pow(1-p, n-i) end)
      |> Enum.sum
    end
  end

  @doc """
  The percentile-point function

  ## Examples

      iex> Statistics.Distributions.Binomial.ppf(10, 0.5).(0.5)
      5

  """
  @spec ppf(non_neg_integer, number) :: fun
  def ppf(n, p) do
    fn x ->
      ppf_tande(x, n, p)
    end
  end

  # trial-and-error method which refines guesses
  # to arbitrary number of decimal places
  defp ppf_tande(x, n, p, g \\ 0) do
    g_cdf = cdf(n, p).(g) 
    cond do
      x > g_cdf ->
        ppf_tande(x, n, p, g+1)
      x <= g_cdf ->
        g
    end
  end


  @doc """
  Draw a random number from a t distribution with specified degrees of freedom

  Uses the [rejection sampling method](https://en.wikipedia.org/wiki/Rejection_sampling)

  ## Examples

      iex> Statistics.Distributions.Binomial.rand(10, 0.5)
      5.0

  """
  @spec rand(non_neg_integer, number) :: non_neg_integer
  def rand(n, p) do
    x = Math.rand() * n 
    if pmf(n, p).(x) > Math.rand() do
      Float.round(x)
    else
      rand(n, p) # keep trying
    end
  end

end

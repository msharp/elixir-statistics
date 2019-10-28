defmodule Statistics.Distributions.Chisq do
  alias Statistics.Math
  alias Statistics.Math.Functions

  @moduledoc """
  Chi square distribution.

  Takes a *degrees of freedom* parameter.
  """

  @doc """
  The probability density function

  ## Examples

      iex> Statistics.Distributions.Chisq.pdf(1).(2)
      0.10377687435514868

  """
  @spec pdf(non_neg_integer) :: fun
  def pdf(df) do
    hdf = df / 2
    g = Math.pow(2, hdf) * Functions.gamma(hdf)

    fn x -> 1 / g * Math.pow(x, hdf - 1) * Math.exp(-1 * x / 2) end
  end

  @doc """
  The cumulative density function

  ## Examples

      iex> Statistics.Distributions.Chisq.cdf(2).(2)
      0.6321205588285578

  """
  @spec cdf(non_neg_integer) :: fun
  def cdf(df) do
    hdf = df / 2.0
    g = Functions.gamma(hdf)

    fn x ->
      b = Functions.gammainc(hdf, x / 2.0)
      b / g
    end
  end

  @doc """
  The percentile-point function

  ## Examples

      iex> Statistics.Distributions.Chisq.ppf(1).(0.95)
      3.841458820694101

  """
  @spec ppf(non_neg_integer) :: fun
  def ppf(df) do
    fn x ->
      ppf_tande(x, cdf(df))
    end
  end

  # trial-and-error method which refines guesses
  # to arbitrary number of decimal places
  defp ppf_tande(x, tcdf, precision \\ 14) do
    ppf_tande(x, tcdf, 0, precision + 2, 0)
  end

  defp ppf_tande(_, _, g, precision, precision) do
    g
  end

  defp ppf_tande(x, tcdf, g, precision, p) do
    increment = 100 / Math.pow(10, p)
    guess = g + increment

    if x < tcdf.(guess) do
      ppf_tande(x, tcdf, g, precision, p + 1)
    else
      ppf_tande(x, tcdf, guess, precision, p)
    end
  end

  @doc """
  Draw a random number from a t distribution with specified degrees of freedom

  Uses the [rejection sampling method](https://en.wikipedia.org/wiki/Rejection_sampling)

  ## Examples

      iex> Statistics.Distributions.Chisq.rand(2)
      1.232433646523534767

  """
  @spec rand(non_neg_integer) :: number
  def rand(df), do: rand(df, cdf(df))

  defp rand(df, rcdf) do
    x = Math.rand() * 100

    if rcdf.(x) > Math.rand() do
      x
    else
      # keep trying
      rand(df, rcdf)
    end
  end
end

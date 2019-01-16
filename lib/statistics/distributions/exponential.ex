defmodule Statistics.Distributions.Exponential do
  @moduledoc """
  Exponential distribution.

  `lambda` is the rate parameter and must be greater than zero.
  """

  alias Statistics.Math

  @doc """
  The probability density function

  ## Examples

      iex> Statistics.Distributions.Exponential.pdf().(1)
      0.36787944117144233

  """
  @spec pdf() :: fun
  @spec pdf(number) :: fun
  def pdf() do
    pdf(1)
  end

  def pdf(lambda) do
    fn x ->
      cond do
        x < 0 ->
          0

        lambda <= 0 ->
          :nan

        true ->
          lambda * Math.exp(-lambda * x)
      end
    end
  end

  @doc """
  The cumulative density function

  ## Examples

      iex> Statistics.Distributions.Exponential.cdf().(1)
      0.6321205588285577

  """
  @spec cdf() :: fun
  @spec cdf(number) :: fun
  def cdf() do
    cdf(1)
  end

  def cdf(lambda) do
    fn x ->
      cond do
        x < 0 ->
          0

        lambda <= 0 ->
          :nan

        true ->
          1 - Math.exp(-lambda * x)
      end
    end
  end

  @doc """
  The percentile-point function

  ## Examples

      iex> Statistics.Distributions.Exponential.ppf().(0.1)
      0.10536051565782628

  """
  @spec ppf() :: fun
  @spec ppf(number) :: fun
  def ppf() do
    ppf(1)
  end

  def ppf(lambda) do
    fn x ->
      cond do
        x == 1 ->
          :inf

        x < 0 or x > 1 or lambda < 0 ->
          :nan

        true ->
          -1 * Math.ln(1 - x) / lambda
      end
    end
  end

  @doc """
  Draw a random variate from the distribution with specified lambda

  Uses the closed-form inverse CDF (PPF) evaluated with uniform number between 0.0 and 1.0

  ## Examples

      iex> Statistics.Distributions.Exponential.rand()
      0.145709384787

  """
  @spec rand() :: number
  @spec rand(number) :: number
  def rand() do
    rand(1)
  end

  def rand(lambda) do
    ppf(lambda).(Math.rand())
  end
end

defmodule Statistics.Distributions.Binomial do
  alias Statistics.Math

  @moduledoc """
  Binomial distribution.

  This models the expected outcome of a number
  of binary trials, each with known probability,
  (often called a Bernoulli trial)
  """

  @doc """
  The probability mass function.

  Note that calling the mass function with a `Float` will return `nil` because
  this is a discrete probability distribution which only includes integer values.

  ## Examples

      iex> Statistics.Distributions.Binomial.pmf(4, 0.5).(2)
      0.375
      iex> Statistics.Distributions.Binomial.pmf(4, 0.5).(0.2)
      nil

  """
  @spec pmf(non_neg_integer, number) :: fun
  def pmf(n, p) do
    fn k ->
      cond do
        k < 0.0 ->
          0.0

        n < k ->
          0.0

        k != Math.to_int(k) ->
          nil

        true ->
          Math.combination(n, k) * Math.pow(p, k) * Math.pow(1 - p, n - k)
      end
    end
  end

  @doc """
  The cumulative density function

  ## Examples

      iex> Statistics.Distributions.Binomial.cdf(4, 0.5).(2)
      0.6875

  """
  @spec cdf(non_neg_integer, number) :: fun
  def cdf(n, p) do
    fn k ->
      0..Math.to_int(Math.floor(k))
      |> Enum.to_list()
      |> Enum.map(fn i -> Math.combination(n, i) * Math.pow(p, i) * Math.pow(1 - p, n - i) end)
      |> Enum.sum()
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
      ppf_tande(x, n, p, cdf(n, p), 0)
    end
  end

  # trial-and-error method which refines guesses
  # to arbitrary number of decimal places
  defp ppf_tande(x, n, p, npcdf, g) do
    g_cdf = npcdf.(g)

    cond do
      x > g_cdf ->
        ppf_tande(x, n, p, npcdf, g + 1)

      x <= g_cdf ->
        g
    end
  end

  @doc """
  Draw a random number from a binomial distribution

  Uses the [rejection sampling method](https://en.wikipedia.org/wiki/Rejection_sampling)
  and returns a rounded `Float`.

  ## Examples

      iex> Statistics.Distributions.Binomial.rand(10, 0.5)
      5.0

  """
  @spec rand(non_neg_integer, number) :: non_neg_integer
  def rand(n, p), do: rand(n, p, pmf(n, p))

  defp rand(n, p, rpmf) do
    x = Math.rand() * n

    if rpmf.(x) > Math.rand() do
      Float.round(x)
    else
      # keep trying
      rand(n, p, rpmf)
    end
  end
end

defmodule Statistics.Distributions.Normal do
  @moduledoc """
  The normal, or gaussian, distribution

  When invoking the distibution functions without parameters, 
  a distribution with mean of 0 and standard deviation of 1 is assumed.
  """

  alias Statistics.Math
  alias Statistics.Math.Functions

  @doc """
  Probability density function

  Roughly the expectation of a given value in the distribution

  ## Examples

      iex> Statistics.Distributions.Normal.pdf().(0)
      0.3989422804014327
      iex> Statistics.Distributions.Normal.pdf(0.2, 1).(1.3)
      0.21785217703255055

  """
  @spec pdf :: fun
  def pdf do
    pdf(0, 1)
  end

  @spec pdf(number, number) :: fun
  def pdf(mu, sigma) do
    fn x ->
      numexp = Math.pow(x - mu, 2) / (2 * Math.pow(sigma, 2))
      denom = sigma * Math.sqrt(2 * Math.pi())
      numer = Math.pow(Math.e(), numexp * -1)
      numer / denom
    end
  end

  @doc """
  The cumulative density function

  The probability that a value lies below `x`

  Cumulative gives a probability that a statistic
  is less than Z. This equates to the area of the distribution below Z.
  e.g:  Pr(Z = 0.69) = 0.7549. This value is usually given in Z tables.

  ## Examples

    iex> Statistics.Distributions.Normal.cdf().(2)
    0.9772499371127437
    iex> Statistics.Distributions.Normal.cdf(0,1).(0)
    0.5000000005

  """
  @spec cdf :: fun
  def cdf() do
    cdf(0, 1)
  end

  @spec cdf(number, number) :: fun
  def cdf(mu, sigma) do
    denom = sigma * Math.sqrt(2)

    fn x ->
      0.5 * (1.0 + Functions.erf((x - mu) / denom))
    end
  end

  @doc """
  The percentile-point function

  Get the maximum point which lies below the given probability.
  This is the inverse of the cdf

  ## Examples

      iex> Statistics.Distributions.Normal.ppf().(0.025)
      -1.96039491692534
      iex> Statistics.Distributions.Normal.ppf(7, 2.1).(0.25)
      5.584202805909036

  """
  @spec ppf :: fun
  def ppf() do
    ppf(0, 1)
  end

  @spec ppf(number, number) :: fun
  def ppf(mu, sigma) do
    res = fn p ->
      mu + p * sigma
    end

    fn x ->
      cond do
        x < 0.5 ->
          res.(-Functions.inv_erf(Math.sqrt(-2.0 * Math.ln(x))))

        x >= 0.5 ->
          res.(Functions.inv_erf(Math.sqrt(-2.0 * Math.ln(1 - x))))
      end
    end
  end

  @doc """
  Draw a random number from a normal distribution

  `rnd/0` will return a random number from a normal distribution
  with a mean of 0 and a standard deviation of 1

  `rnd/2` allows you to provide the mean and standard deviation
  parameters of the distribution from which the random number is drawn

  Uses the [rejection sampling method](https://en.wikipedia.org/wiki/Rejection_sampling)

  ## Examples

      iex> Statistics.Distributions.Normal.rand()
      1.5990817245679434
      iex> Statistics.Distributions.Normal.rand(22, 2.3)
      23.900248900049736

  """
  @spec rand() :: number
  def rand do
    rand(0, 1)
  end

  @spec rand(number, number) :: number
  def rand(mu, sigma), do: rand(mu, sigma, pdf(0, 1))

  defp rand(mu, sigma, rpdf) do
    # Note: an alternate method exists and may be better
    # Inverse transform sampling - https://en.wikipedia.org/wiki/Inverse_transform_sampling
    # ----
    # Generate a random number between -10,+10
    # (probability of 10 ocurring in a Normal(0,1) distribution is
    # too small to calculate with the precision available to us)
    x = Math.rand() * 20 - 10

    cond do
      rpdf.(x) > Math.rand() ->
        # transpose to specified distribution
        mu - x * sigma

      true ->
        # keep trying
        rand(mu, sigma, rpdf)
    end
  end
end

defmodule Statistics.Distributions.Normal do

  @moduledoc """
  The normal, or gaussian, distribution
  """

  alias Statistics.Math
  alias Statistics.Math.Functions

  @doc """
  Probability density function

  get result of probability density function

  ## Examples

      iex> Statistics.Distributions.Normal.pdf(0)
      0.3989422804014327
      iex> Statistics.Distributions.Normal.pdf(1.3, 0.2, 1)
      0.21785217703255055

  """
  def pdf(x) do
    pdf(0, 1).(x)
  end

  def pdf(x, mu, sigma) do
    pdf(mu, sigma).(x)
  end

  # return functions

  def pdf(mu, sigma) do
    fn x ->
      numexp = Math.pow((x - mu), 2) / (2 * Math.pow(sigma, 2))
      denom = sigma * Math.sqrt((2 * Math.pi))
      numer = Math.pow(Math.e, (numexp * -1))
      numer / denom
    end
  end


  @doc """
  Get the probability that a value lies below `x`

  Cumulative gives a probability that a statistic
  is less than Z. This equates to the area of the distribution below Z.
  e.g:  Pr(Z = 0.69) = 0.7549. This value is usually given in Z tables.

  ## Examples

    iex> Statistics.Distributions.Normal.cdf(2)
    0.9772499371127437
    iex> Statistics.Distributions.Normal.cdf(0)
    0.5000000005

  """
  def cdf(x) do
    cdf(x, 0, 1)
  end

  def cdf(x, mu, sigma) do
    0.5 * (1.0 + Functions.erf((x - mu) / (sigma * Math.sqrt(2))))
  end


  @doc """
  The percentile-point function

  Get the maximum point which lies below the given probability.
  This is the inverse of the cdf

  ## Examples

      iex> Statistics.Distributions.Normal.ppf(0.025)
      -1.96039491692534
      iex> Statistics.Distributions.Normal.ppf(0.25, 7, 2.1)
      5.584202805909036

  """
  def ppf(x) do
    ppf(x, 0, 1)
  end
  def ppf(x, mu, sigma) do
    if x < 0.5 do
      p = -Functions.inv_erf(Math.sqrt(-2.0*Math.ln(x)))
    else
      p = Functions.inv_erf(Math.sqrt(-2.0*Math.ln(1-x)))
    end
    mu + (p * sigma)
  end

  @doc """
  Draw a random number from a normal distribution

  `rnd/0` will return a random number from a normal distribution
  with a mean of 0 and a standard deviation of 1

  `rnd/3` allows you to provide the mean and standard deviation
  parameters of the distribution from which the random number is drawn

  Uses the [rejection sampling method](https://en.wikipedia.org/wiki/Rejection_sampling)

  ## Examples

      iex> Statistics.Distributions.Normal.rand()
      1.5990817245679434
      iex> Statistics.Distributions.Normal.rand(22, 2.3)
      23.900248900049736

  """
  def rand do
    rand(0, 1)
  end

  def rand(mu, sigma) do
    # Note: an alternate method exists and may be better
    # Inverse transform sampling - https://en.wikipedia.org/wiki/Inverse_transform_sampling
    # ----
    # Generate a random number between -10,+10
    # (probability of 10 ocurring in a Normal(0,1) distribution is
    # too small to calculate with the precision available to us)
    x = Math.rand() * 20 - 10
    {rmu, rsigma} = {0, 1}
    if pdf(x, rmu, rsigma) > Math.rand() do
      # get z-score
      z = (rmu - x) / rsigma
      # transpose to specified distribution
      mu + (z * sigma)
    else
      rand(mu, sigma) # keep trying
    end
  end

end

defmodule Statistics.Distributions.Beta do
  alias Statistics.Math
  alias Statistics.Math.Functions

  @moduledoc """
  The Beta distribution
  """

  @doc """
  The probability density function

  ## Examples

      iex> Statistics.Distributions.Beta.pdf(1,100).(0.1)
      0.0029512665430652825

  """
  @spec pdf(number, number) :: fun
  def pdf(alpha, beta) do
    bab = Functions.beta(alpha, beta)

    fn x ->
      cond do
        x <= 0.0 ->
          0.0

        true ->
          (Math.pow(x, alpha - 1) * Math.pow(1 - x, beta - 1)) / bab
      end
    end
  end

  @doc """
  The maximum value of the probability density function

  ## Examples

      iex> Statistics.Distributions.Beta.pdf_max(2,6)
      2.813143004115228

  """
  @spec pdf_max(number, number) :: number
  def pdf_max(alpha, beta) do
    if alpha <= 1 || beta <= 1 || (alpha+beta) <= 2 do
      1.0
    else
      pdf(alpha, beta).((alpha - 1) / (alpha + beta - 2))
    end
  end

  @doc """
  The cumulative density function

  ## Examples

      iex> Statistics.Distributions.Beta.cdf(1,100).(0.1)
      0.9996401052677814

  """
  @spec cdf(number, number) :: fun
  def cdf(alpha, beta) do
    fn x ->
      Functions.simpson(pdf(alpha, beta), 0, x, 10000)
    end
  end

  @doc """
  The percentile-point function

  ## Examples

      iex> Statistics.Distributions.Beta.ppf(1,100).(0.1)
      0.001053089271799999

  """
  @spec ppf(number, number) :: fun
  def ppf(alpha, beta) do
    fn x ->
      ppf_tande(cdf(alpha, beta), x)
    end
  end

  defp ppf_tande(cdf, x) do
    ppf_tande(cdf, x, 0.0, 14, 0)
  end

  defp ppf_tande(_, _, guess, precision, precision) do
    guess
  end

  defp ppf_tande(cdf, x, guess, precision, current_precision) do
    # add 1/10**precision'th of the max value to the min
    new_guess = guess + 1 / Math.pow(10, current_precision)
    # if it's less than the PPF we want, do it again
    if cdf.(new_guess) < x do
      ppf_tande(cdf, x, new_guess, precision, current_precision)
    else
      # otherwise (it's greater), increase the current_precision
      # and recurse with original guess
      ppf_tande(cdf, x, guess, precision, current_precision + 1)
    end
  end

  @doc """
  Draw a random number from a Beta distribution

  ## Examples

      iex> Statistics.Distributions.Beta.rand(1,100)
      0.005922672626035741

  """
  @spec rand(number, number) :: number
  def rand(alpha, beta) do
    rpdf = pdf(alpha, beta)
    rpdf_max = pdf_max(alpha, beta)
    rand_sampling(rpdf, rpdf_max)
  end

  defp rand_sampling(rpdf, rpdf_max) do
    # beta only exists between 0 and 1
    x = Math.rand()

    if rpdf.(x) > Math.rand() * rpdf_max do
      x
    else
      # keep trying
      rand_sampling(rpdf, rpdf_max)
    end
  end
end

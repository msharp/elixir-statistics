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
  @spec pdf(number,number) :: fun
  def pdf(a, b) do
    fn x ->
      cond do
        x <= 0.0 ->
          0.0
        true ->
          (Math.pow(x, a-1) * Math.pow(1-x, b-1)) / Functions.beta(a, b)
      end
    end
  end

  @doc """
  The cumulative density function

  ## Examples

      iex> Statistics.Distributions.Beta.cdf(1,100).(0.1)
      0.9996401052677814
      
  """
  @spec cdf(number,number) :: fun
  def cdf(a, b) do
    fn x ->
      Functions.simpson(pdf(a, b), 0, x, 10000)
    end
  end

  @doc """
  The percentile-point function

  ## Examples

      iex> Statistics.Distributions.Beta.ppf(1,100).(0.1)
      0.001053089271799999
      
  """
  @spec ppf(number,number) :: fun
  def ppf(a, b) do
    fn x ->
      ppf_tande(cdf(a, b), x)
    end
  end
  defp ppf_tande(cdf, x) do
    ppf_tande(cdf, x, 0.0, 0.0, 1.0, 14, 0)
  end
  defp ppf_tande(_, _, guess, _, _, precision, precision) do
    guess
  end
  defp ppf_tande(cdf, x, guess, min, max, precision, current_precision) do
    # add 1/10**precision'th of the max value to the min
    new_guess = guess + (1/ Math.pow(10, current_precision))
    # if it's less than the PPF we want, do it again
    if cdf.(new_guess) < x do
      ppf_tande(cdf, x, new_guess, min, max, precision, current_precision)
    else
      # otherwise (it's greater), increase the current_precision
      # and recurse with original guess
      ppf_tande(cdf, x, guess, min, max, precision, current_precision+1)
    end
  end

  @doc """
  Draw a random number from a Beta distribution

  ## Examples

      iex> Statistics.Distributions.Beta.rand(1,100)
      0.005922672626035741

  """
  @spec rand(number,number) :: number
  def rand(a, b) do
    x = Math.rand() # beta only exists between 0 and 1
    if pdf(a, b).(x) > Math.rand() do
      x
    else
      rand(a, b) # keep trying
    end
  end

end

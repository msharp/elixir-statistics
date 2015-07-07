defmodule Statistics.Distributions.T do

  alias Statistics.Math
  alias Statistics.Math.Functions, as: F

  @moduledoc """
  Student's t distribution.

  This distribution is always centered around 0.0 and allows a *degrees of freedom* parameter.
  """

  @doc """
  The probability density function

  ## Examples

      iex> Statistics.Distributions.T.pdf(0, 3)
      0.3675525969478612
      iex> Statistics.Distributions.T.pdf(3.2, 1)
      0.028319384891796327

  """
  def pdf(x, df) do
    F.gamma((df+1)/2) / (Math.sqrt(df*Math.pi) * F.gamma(df/2) ) * Math.pow((1 + (x*x/df)), ((df+1)/2)*-1)
  end

  @doc """
  The cumulative density function

  ## Examples

      iex> Statistics.Distributions.T.cdf(0, 3)
      0.5
      
  """
  def cdf(x, df) do
    df_2 = (df+1)/2
    hyp_x = -1 * (Math.pow(x, 2) / df)
    p1 = x * F.gamma(df_2)
    p2n = F.hyp2f1(0.5, df_2, 1.5, hyp_x)
    p2d = Math.sqrt(Math.pi * df) * F.gamma(df / 2)
    #IO.puts "p1 = #{p1}; p2n = #{p2n}; p2d = #{p2d}"
    0.5 + p1 * (p2n / p2d)
  end

  @doc """
  The percentile-point function

  """
  def ppf(x, _) when x == 0.5 do
    0.0
  end
  def ppf(x, df) do
    ppf_tande(x, df)
  end
  # trial-and-error method which refines guesses
  # to arbitrary number of decimal places
  defp ppf_tande(x, df, precision \\ 4) do
    ppf_tande(x, df, -2, precision+2, precision)
  end
  defp ppf_tande(_, _, g, precision, precision) do
    g
  end
  defp ppf_tande(x, df, g, precision, p) do
    #IO.puts "g = #{g}"
    increment = 100 / Math.pow(10, p)
    #IO.puts "increment = #{increment}"
    guess = g + increment
    #IO.puts "guess = #{guess}"
    if x < cdf(guess, df) do
      ppf_tande(x, df, g, precision, p+1)
    else
      ppf_tande(x, df, guess, precision, p)
    end
  end

  @doc """
  Draw a random number from a t distribution with specified degrees of freedom
  """
  def rand(df) do
    x = Math.rand() * 50 - 25 # t-dist is fatter-tailed than normal
    if pdf(x, df) > Math.rand() do
      x
    else
      rand(df) # keep trying
    end
  end

end

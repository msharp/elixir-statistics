defmodule Statistics.Distributions.T do

  alias Statistics.MathHelpers, as: Math

  @moduledoc """
  Student's t distribution.

  This distribution is always centered around 0.0 and allows a *degrees of freedom* parameter.
  """

  @doc """
  The probability density function

  ## Examples

      iex> Statistics.Distributions.T.pdf(0, 3)
      0.36755259694786124
      iex> Statistics.Distributions.T.pdf(3.2)
      0.02831938489179633

  """
  def pdf(x, df) do
    gamma((df+1)/2) / (Math.sqrt(df*Math.pi) * gamma(df/2) ) * Math.pow((1 + (x*x/df)), ((df+1)/2)*-1)
  end
  def pdf(x) do
    pdf(x, 1)
  end

  @doc """
  The cumulative density function
  """
  def cdf(x) do
    0.0
  end

  @doc """
  The percentile-point function
  """
  def ppf(x) do
    0.0
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


  @doc """
  The Gamma function

  Two implementations available here:

      - Using Taylor series coefficients 
      - using the [Lanczos approximation](http://en.wikipedia.org/wiki/Lanczos_approximation)
  
  """
  def gamma(x) do
    gamma_lanczos(x)
    #gamma_taylor(x)
  end

  defp gamma_lanczos(x) do
    # coefficients used by the GNU Scientific Library
    g = 7
    p = [0.99999999999980993, 676.5203681218851, -1259.1392167224028,
         771.32342877765313, -176.61502916214059, 12.507343278686905,
         -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7]
    # recursive formula
    if x < 0.5 do
      Math.pi / (:math.sin(Math.pi*x) * gamma_lanczos(1-x))
    else
      z = x - 1
      xs = for i <- 1..8, do: Enum.at(p, i)/(z+i)
      x = Enum.at(p, 0) + Enum.sum(xs)
      t = z + g + 0.5
      Math.sqrt(2*Math.pi) * Math.pow(t, (z+0.5)) * Math.exp(-1*t) * x
    end
  end

  defp gamma_taylor(x) do
    a = [1.00000000000000000000, 0.57721566490153286061, -0.65587807152025388108,
        -0.04200263503409523553, 0.16653861138229148950, -0.04219773455554433675,
        -0.00962197152787697356, 0.00721894324666309954, -0.00116516759185906511,
        -0.00021524167411495097, 0.00012805028238811619, -0.00002013485478078824,
        -0.00000125049348214267, 0.00000113302723198170, -0.00000020563384169776,
        0.00000000611609510448, 0.00000000500200764447, -0.00000000118127457049,
        0.00000000010434267117, 0.00000000000778226344, -0.00000000000369680562,
        0.00000000000051003703, -0.00000000000002058326, -0.00000000000000534812,
        0.00000000000000122678, -0.00000000000000011813, 0.00000000000000000119,
        0.00000000000000000141, -0.00000000000000000023] # , 0.00000000000000000002]

    sm = 0.00000000000000000002
    1.0 / gamma_taylor_map(x-1.0, Enum.reverse(a), sm)
  end
  defp gamma_taylor_map(y, [], acc) do
    acc
  end
  defp gamma_taylor_map(y, [h|t], acc) do
    gamma_taylor_map(y, t, acc * y + h)
  end


  @doc """
  The Beta function
  """
  def beta(x, y) do
    # from https://en.wikipedia.org/wiki/Beta_function#Properties
    gamma(x) * gamma(y) / gamma(x + y)
  end

end




defmodule Statistics.Math.Functions do

  alias Statistics.Math

  @doc """
  The Gamma function

  This implementation uses the [Lanczos approximation](http://en.wikipedia.org/wiki/Lanczos_approximation)

  ## Examples
   
      iex> Statistics.Math.Functions.gamma(0.5)
      1.7724538509055163

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

  @doc """
  The Beta function

  ## Examples 

      iex> Statistics.Math.Functions.beta(2, 0.5)
      1.3333333333333328

  """
  def beta(x, y) do
    # from https://en.wikipedia.org/wiki/Beta_function#Properties
    gamma(x) * gamma(y) / gamma(x + y)
  end

  @doc """ 
  Incomplete Gamma function
    
  ## Examples 

      i2ex> Statistics.Math.Functions.gammainc(1,1)
      0.63212055882855778

  """
  # ############################
  # this simple approach adapted from 
  # http://www.dreamincode.net/forums/topic/12775-statistical-functions/
  # 
  # there are alternate implementation strategies to try
  #
  #   : https://mail.python.org/pipermail/python-list/2001-April/092498.html
  #   : http://www.dreamincode.net/forums/topic/12775-statistical-functions/
  #   : http://www.crbond.com/math.htm
  #  
  # ###########################
  def gammainc(a, x) do
    Math.pow(x, a) * Math.exp(-x) * gammainc_sum(a, x, 1/a, 0, 1)
  end
  defp gammainc_sum(_, _, t, s, _) when t == 0.0 do
    s
  end
  defp gammainc_sum(a, x, t, s, n) do
    s = s + t
    t = t * (x / (a + n))
    gammainc_sum(a, x, t, s, n+1)
  end

  @doc """
  Hypergeometrc 2F1 function
  """
  # from http://mhtlab.uwaterloo.ca/courses/me755/web_chap7.pdf
  def hyp2f1(a, b, c, x) do
    pb = gamma(c)/gamma(a)*gamma(b)
    pa = hyp2f1_cont(a, b, c, x)
    pb * pa
  end
  defp hyp2f1_cont(a, b, c, x) do
    hyp2f1_cont(a, b, c, x, 0, 0)
  end
  defp hyp2f1_cont(_, _, _, _, n, acc) when n > 50 do
    acc
  end
  defp hyp2f1_cont(a, b, c, x, n, acc) do
    s = gamma(a+n) * gamma(b+n) / gamma(c+n)
    p = Math.pow(x, n) / Math.factorial(n)
    hyp2f1_cont(a, b, c, x, n+1, acc+(s*p))
  end


  @doc """
  Simpsons rule for numerical intergation of a function

  see: http://en.wikipedia.org/wiki/Simpson's_rule

  ## Examples

    iex> Statistics.Math.Functions.simpson(fn x -> x*x*x end, 0, 20, 100000)
    40000.00000000011

  """
  def simpson(f, a, b, n) do
    h = (b - a) / n
    s = f.(a) + f.(b) + 
      ( Stream.take_every(1..n-1, 2) 
        |> Enum.map(fn i -> 4 * f.(a + i * h) end)
        |> Enum.sum ) + 
      ( Stream.take_every(2..n-2, 2) 
        |> Enum.map(fn i -> 2 * f.(a + i * h) end)
        |> Enum.sum
    )

    s * h / 3
  end

end

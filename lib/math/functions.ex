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
  The 'error' function

  Formula 7.1.26 given in Abramowitz and Stegun.
  Formula appears as 1 – (a1t1 + a2t2 + a3t3 + a4t4 + a5t5)exp(-x2)

  """
  #Some wisdom in Horner's Method of coding polynomials:
  #  - We could evaluate a polynomial of the form a + bx + cx^2 + dx^3 by coding as a + b*x + c*x*x + d*x*x*x.
  #  - But we can save computational power by coding it as ((d*x + c)*x + b)*x + a.
  #  - The formula below was coded this way bringing down the complexity of this algorithm from O(n2) to O(n).''
  def erf(x) do
    # constants
    {a1, a2, a3, a4, a5} = {0.254829592, -0.284496736, 1.421413741, -1.453152027, 1.061405429}
    p  =  0.3275911
        
    # Save the sign of x
    sign = if x < 0, do: -1, else: 1
    x = abs(x)
    
    # Formula 7.1.26 given in Abramowitz and Stegun.
    t = 1.0/(1.0 + p*x)
    y = 1.0 - (((((a5*t + a4)*t) + a3)*t + a2)*t + a1) * t * Math.pow(Math.e, (-x*x))
    
    sign * y
  end

  @doc """ 
  The  inverse 'error' function
  """
  def inv_erf(x) do
    # constants
    {c0, c1, c2} = {2.515517, 0.802853, 0.010328}
    {d0, d1, d2} = {1.432788, 0.189269, 0.001308}
    # formula
    x - ((c2*x + c1)*x + c0) / (((d2*x + d1)*x + d0)*x + 1.0)
  end 

  @doc """ 
  Lower incomplete Gamma function
    
  ## Examples 

      iex> Statistics.Math.Functions.gammainc(1,1)
      0.63212055882855778

  """
  # ############################
  # this simple approach adapted from 
  # http://www.dreamincode.net/forums/topic/12775-statistical-functions/
  # 
  # there are alternate implementation strategies to try, 
  # for examples, see:
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
  Hypergeometrc 2F1 functiono

  

  """
  def hyp2f1(a, b, c, z) when z == 1 do 
    # TODO: the following logic can be simplified
    convergent = (c-a-b) > 0
    finite = (isint(a) and a <= 0) or (isint(b) and b <= 0)
    zerodiv = isint(c) and c <= 0 and not ((isint(a) and c <= a <= 0) or (isint(b) and c <= b <= 0))
    #print "bz", a, b, c, z, convergent, finite, zerodiv
    # Gauss's theorem gives the value if convergent
    if (convergent or finite) and not zerodiv do
      gammainc(c, c-a)
    else
      # Otherwise, there is a pole and we take the
      # sign to be that when approaching from below
      # XXX: this evaluation is not necessarily correct in all cases
      hyp2f1(a,b,c,1-eps*2) # * ctx.inf
    end
  end
  
  def hyp2f1(a, b, c, z) when z == 0 do 
    # Division by zero but power of z is higher than
    # first order so cancels
    if c > 0 or c < 0 or a == 0 or b == 0 do
      1+z
    else
      # Indeterminate
      :inf
    end
  end

  defp isint(i) do
    Math.round(i,0) == i
  end
  defp eps do
    2.2204460492503131e-16
  end

  #####################
  #
  # WARNING: the implementation is incomplete, and should not be used
  # from http://mhtlab.uwaterloo.ca/courses/me755/web_chap7.pdf
  def old_hyp2f1(a, b, c, x) do
    pb = gamma(c)/gamma(a)*gamma(b)
    pa = old_hyp2f1_cont(a, b, c, x)
    pb * pa
  end
  defp old_hyp2f1_cont(a, b, c, x) do
    old_hyp2f1_cont(a, b, c, x, 0, 0)
  end
  defp old_hyp2f1_cont(_, _, _, _, n, acc) when n > 50 do
    acc
  end
  defp old_hyp2f1_cont(a, b, c, x, n, acc) do
    s = gamma(a+n) * gamma(b+n) / gamma(c+n)
    p = Math.pow(x, n) / Math.factorial(n)
    old_hyp2f1_cont(a, b, c, x, n+1, acc+(s*p))
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
    s = f.(a) + f.(b) + ( 
      Stream.take_every(1..n-1, 2) 
        |> Enum.map(fn i -> 4 * f.(a + i * h) end)
        |> Enum.sum 
      ) + (
      Stream.take_every(2..n-2, 2) 
        |> Enum.map(fn i -> 2 * f.(a + i * h) end)
        |> Enum.sum 
      )
    s * h / 3
  end

end

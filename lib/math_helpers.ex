defmodule Statistics.MathHelpers do

  @e 2.718281828459045
  @pi :math.pi
  
  @doc """
  Get square root 
  
  return sqrt from Erlang
  
  ## Examples

      iex> Statistics.MathHelpers.sqrt(9)
      3.0
      iex> Statistics.MathHelpers.sqrt(99)
      9.9498743710662

  """
  def sqrt(num) do
    :math.sqrt(num)
  end

  @doc """ 
  Get power from Erlang

  This is needed because Elixir doesn't 
  currently have the `**` operator

  ## Examples

      iex> Statistics.MathHelpers.pow(2,3)
      8.0
      iex> Statistics.MathHelpers.pow(9,9)
      387420489.0
      iex> Statistics.MathHelpers.pow(2,0)
      1
      iex> Statistics.MathHelpers.pow(-2, 1.5)
      -2.8284271247461903
      iex> Statistics.MathHelpers.pow(0, 5)
      0

  """
  def pow(_, pow) when pow == 0.0 do
    1
  end
  def pow(num, _) when num == 0.0 do
    0 # not always true, raising 0 to a negative number is NaN
  end
  # erlang doesn't like raising negative numbers to non-integer powers
  def pow(num, pow) when num < 0 and is_float(pow) do
   :math.pow(-num, pow) * -1
  end
  def pow(num, pow) do
    :math.pow(num, pow)
  end

  @doc """
  The constant *e*

  ## Examples

      iex> Statistics.MathHelpers.e
      2.718281828459045

  """
  def e do
    @e
  end

  @doc """
  The constant *pi*

  (returned from Erlang Math module)

  ## Examples

      iex> Statistics.MathHelpers.pi
      3.141592653589793

  """
  def pi do
    @pi
  end

  @doc """
  The natural log

  ( from Erlang Math module)

  ## Examples
  
      iex> Statistics.MathHelpers.ln(20)
      2.995732273553991
      iex> Statistics.MathHelpers.ln(200)
      5.298317366548036

  """
  def ln(i) do
    :math.log(i)
  end

  @doc """
  Exponent function

  Raise *e* to given power

  """
  def exp(x) do
    pow(@e, x)
  end

  @doc """
  Get a random number from erlang
  """
  def rand() do
    :random.uniform()
  end

  @doc """
  Round a decimal to a specific precision

  ## Examples 

      iex> Statistics.MathHelpers.round(0.123456, 4)
      0.1235

  """
  def round(x, precision) do
    p = pow(10, precision)
    :erlang.round(x * p) / p
  end

  @doc """
  Get the absolute value of a number

  ## Examples 

      iex> Statistics.MathHelpers.abs(-4)
      4

  """
  def abs(x) when x < 0 do
    x * -1
  end
  def abs(x) do
    x
  end

  @doc """
  Get the base integer from a float

  ## Examples

      iex> Statistics.MathHelpers.to_int(66.6666)
      66

  """
  def to_int(f) do
    s = Float.to_string Float.floor(f), [decimals: 0, compact: true]
    {i, _} = Integer.parse(s)
    i
  end

  ################################
  
  @doc """
  The Gamma function

  This implementation uses the [Lanczos approximation](http://en.wikipedia.org/wiki/Lanczos_approximation)

  ## Examples
   
      iex> Statistics.MathHelpers.gamma(0.5)
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
      pi / (:math.sin(pi*x) * gamma_lanczos(1-x))
    else
      z = x - 1
      xs = for i <- 1..8, do: Enum.at(p, i)/(z+i)
      x = Enum.at(p, 0) + Enum.sum(xs)
      t = z + g + 0.5
      sqrt(2*pi) * pow(t, (z+0.5)) * exp(-1*t) * x
    end
  end

  @doc """
  The Beta function

  ## Examples 

      iex> Statistics.MathHelpers.beta(2, 0.5)
      1.3333333333333328

  """
  def beta(x, y) do
    # from https://en.wikipedia.org/wiki/Beta_function#Properties
    gamma(x) * gamma(y) / gamma(x + y)
  end

  @doc """ 
  Incomplete Gamma function
    
  ## Examples 

      iex> Statistics.MathHelpers.gammainc(1,1)
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
    pow(x, a) * exp(-x) * gammainc_sum(a, x, 1/a, 0, 1)
  end
  defp gammainc_sum(_, _, t, s, _) when t == 0.0 do
    s
  end
  defp gammainc_sum(a, x, t, s, n) do
    s = s + t
    t = t * (x / (a + n))
    gammainc_sum(a, x, t, s, n+1)
  end


end

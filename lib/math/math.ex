defmodule Statistics.Math do

  @e 2.718281828459045
  @pi :math.pi
  
  @doc """
  Get square root 
  
  return sqrt from Erlang
  
  ## Examples

      iex> Statistics.Math.sqrt(9)
      3.0
      iex> Statistics.Math.sqrt(99)
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

      iex> Statistics.Math.pow(2,3)
      8.0
      iex> Statistics.Math.pow(9,9)
      387420489.0
      iex> Statistics.Math.pow(2,0)
      1
      iex> Statistics.Math.pow(-2, 1.5)
      -2.8284271247461903
      iex> Statistics.Math.pow(0, 5)
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

      iex> Statistics.Math.e
      2.718281828459045

  """
  def e do
    @e
  end

  @doc """
  The constant *pi*

  (returned from Erlang Math module)

  ## Examples

      iex> Statistics.Math.pi
      3.141592653589793

  """
  def pi do
    @pi
  end

  @doc """
  The natural log

  ( from Erlang Math module)

  ## Examples
  
      iex> Statistics.Math.ln(20)
      2.995732273553991
      iex> Statistics.Math.ln(200)
      5.298317366548036

  """
  def ln(i) do
    :math.log(i)
  end

  @doc """
  Exponent function

  Raise *e* to given power

  ## Examples

      iex> Statistics.Math.exp(5.6)
      270.4264074261525

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

      iex> Statistics.Math.round(0.123456, 4)
      0.1235

  """
  def round(x, precision) do
    p = pow(10, precision)
    :erlang.round(x * p) / p
  end

  @doc """
  Get the absolute value of a number

  ## Examples 

      iex> Statistics.Math.abs(-4)
      4

  """
  def abs(x) when x < 0 do
    x * -1
  end
  def abs(x) do
    x
  end

  @doc """
  Factorial!
  """
  def factorial(0) do
    1
  end
  def factorial(1) do
    1
  end
  def factorial(n) do
    l = for i <- n-1..1, do: i
    List.foldl(l, n, fn(x, acc) -> x*acc end)
  end

  @doc """
  Get the base integer from a float

  ## Examples

      iex> Statistics.Math.to_int(66.6666)
      66

  """
  def to_int(f) do
    s = Float.to_string Float.floor(f), [decimals: 0, compact: true]
    {i, _} = Integer.parse(s)
    i
  end

end

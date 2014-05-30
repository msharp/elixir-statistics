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

  """
  def pow(num,pow) do
    :math.pow(num,pow)
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

end

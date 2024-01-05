defmodule Statistics.Math do
  @e :math.exp(1)
  @pi :math.pi()

  @doc """
  Get square root

  return sqrt from Erlang

  ## Examples

      iex> Statistics.Math.sqrt(9)
      3.0
      iex> Statistics.Math.sqrt(99)
      9.9498743710662

  """
  @spec sqrt(number) :: number
  defdelegate sqrt(num), to: :math

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
  @spec pow(number, number) :: number
  def pow(_, 0), do: 1
  def pow(0, pow) when pow >= 0, do: 0
  # Erlang doesn't like raising negative numbers to non-integer powers
  def pow(num, pow) when num < 0 and is_float(pow) do
    :math.pow(-num, pow) * -1
  end

  # otherwise let erlang do it
  defdelegate pow(num, pow), to: :math

  @doc """
  The constant *e*

  ## Examples

      iex> Statistics.Math.e
      2.718281828459045

  """
  @spec e() :: number
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
  @spec pi() :: number
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
  @spec ln(number) :: number
  defdelegate ln(i), to: :math, as: :log

  @doc """
  Exponent function

  Raise *e* to given power

  ## Examples

      iex> Statistics.Math.exp(5.6)
      270.42640742615254

  """
  @spec exp(number) :: number
  defdelegate exp(x), to: :math

  @doc """
  Get a random number from erlang
  """
  @spec rand() :: number
  defdelegate rand(), to: :rand, as: :uniform

  @doc """
  Round a decimal to a specific precision

  ## Examples

      iex> Statistics.Math.round(0.123456, 4)
      0.1235

  """
  @spec round(number, number) :: number
  def round(x, precision) do
    p = pow(10, precision)
    :erlang.round(x * p) / p
  end

  @doc """
  Floor function

  ## Examples

      iex> Statistics.Math.floor(3.999)
      3.0

  """
  @spec floor(number) :: number
  def floor(x) do
    f = :erlang.trunc(x) * 1.0

    cond do
      x - f >= 0 ->
        f

      x - f < 0 ->
        f - 1
    end
  end

  @doc """
  Ceiling function

  ## Examples

      iex> Statistics.Math.ceil(3.999)
      4.0

  """
  @spec ceil(number) :: number
  def ceil(x) do
    f = :erlang.trunc(x) * 1.0

    cond do
      x - f > 0 ->
        f + 1

      x - f <= 0 ->
        f
    end
  end

  @doc """
  Get the absolute value of a number

  ## Examples

      iex> Statistics.Math.abs(-4)
      4

  """
  @spec abs(number) :: number
  defdelegate abs(x), to: :erlang

  @doc """
  Factorial!
  """
  @spec factorial(non_neg_integer) :: non_neg_integer
  def factorial(n) when n < 0 do
    raise ArithmeticError, message: "Argument n must be a positive number"
  end

  def factorial(n) when n == 0 or n == 1 do
    1
  end

  def factorial(n) do
    (to_int(n) - 1)..1
    |> Enum.to_list()
    |> List.foldl(n, fn x, acc -> x * acc end)
  end

  @doc """
  Get the base integer from a float

  ## Examples

      iex> Statistics.Math.to_int(66.6666)
      66

  """
  @spec to_int(number) :: integer
  defdelegate to_int(f), to: :erlang, as: :trunc

  @doc """
  The number of k combinations of n

  Both arguments must be integers greater than zero. `k` may not be larger than `n`.

  ## Examples

      iex> Statistics.Math.combination(10, 3)
      120

  """
  @spec combination(non_neg_integer, non_neg_integer) :: non_neg_integer
  def combination(n, k) when k > n, do: 0
  def combination(n, _) when n < 0, do: 0
  def combination(_, k) when k < 0, do: 0

  def combination(n, k) do
    :erlang.div(factorial(n), factorial(k) * factorial(n - k))
  end

  @doc """
  The number of k permuations of n

  Both arguments must be integers greater than zero. `k` may not be larger than `n`.

  ## Examples

      iex> Statistics.Math.permutation(10, 3)
      720

  """
  @spec permutation(non_neg_integer, non_neg_integer) :: non_neg_integer
  def permutation(n, k) when k > n, do: 0
  def permutation(n, _) when n < 0, do: 0
  # def permutation(_, k) when k < 0, do: 0
  def permutation(n, k) do
    :erlang.div(factorial(n), factorial(n - k))
  end
end

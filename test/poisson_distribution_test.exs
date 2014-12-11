defmodule PoissonDistributionTest do
  use ExUnit.Case, async: true
  doctest Statistics.Distributions.Poisson, except: [rand: 1]

  alias Statistics.Distributions.Poisson
  alias Statistics.Math

  """
  to get mitigate the vagaries of floating-point math 
  and rounding errors, test equivalence to 4 decimal places
  """
  def assert_p(left, right, precision \\ 4) do
      assert Math.round(left, precision) == Math.round(right, precision) 
  end

  test "output of the pmf function" do
    assert Poisson.pmf(1, 1) == 0.36787944117144233
    assert Poisson.pmf(10, 10) == 0.12511003572113336
  end

  test "return a cdf " do
    assert Poisson.cdf(1, 1) == 0.73575888234288467
    assert Poisson.cdf(5, 10) == 0.06708596287903182
  end

  test "get the percentile point value" do
    assert Poisson.ppf(0.95, 1) == 3.0
    # assert Poisson.ppf(0.05, 10) == 5.0
  end

end

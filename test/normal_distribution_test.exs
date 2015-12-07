defmodule NormalDistributionTest do
  use ExUnit.Case, async: true
  doctest Statistics.Distributions.Normal, except: [rand: 0, rand: 3]

  alias Statistics.Distributions.Normal, as: Norm
  alias Statistics.Math

  # to get mitigate the vagaries of floating-point math
  # and rounding errors, test equivalence to 4 decimal places
  def assert_p(left, right, precision \\ 4) do
      assert Math.round(left, precision) == Math.round(right, precision)
  end

  test "output of the pdf function" do
    assert Norm.pdf(0) == 0.3989422804014327
    assert Norm.pdf(3, 0.2, 1) == 0.00791545158297997
    assert Norm.pdf(-1) == 0.24197072451914337
    assert Norm.pdf(22.0, 23.5, 1.7) == 0.15900173884840293
  end

  test "return a cdf " do
    assert Norm.cdf(2) == 0.9772499371127437
    assert_p Norm.cdf(0), 0.5
    assert Norm.cdf(2.8, 2, 2.5) == 0.6255157658802836
    assert_p Norm.cdf(2, 2, 2.5), 0.5
  end

  test "return a normally-distributed random number" do
    assert is_float Norm.rand()
    rands = for _ <- 0..10000, do: Norm.rand(5, 1.5)
    assert_p Statistics.mean(rands), 5, 1
    assert_p Statistics.stdev(rands), 1.5, 1
  end

  test "get the percentile point value" do
    assert Norm.ppf(0.975) == 1.9603949169253396
    assert Norm.ppf(0.025) == -1.96039491692534
    assert Norm.ppf(0.75) == 0.6741891400433162
    assert Norm.ppf(0.25, 7, 2.1) == 5.584202805909036
    assert Norm.ppf(0.95, 37.66, 1.31) == 39.81522698658839
  end

end

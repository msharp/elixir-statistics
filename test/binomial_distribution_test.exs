defmodule BinomialDistributionTest do
  use ExUnit.Case, async: true
  doctest Statistics.Distributions.Binomial, except: [rand: 0, rand: 3]

  alias Statistics.Distributions.Binomial, as: Binom
  alias Statistics.Math

  test "output of the pmf function" do
    assert Binom.pmf(4, 0.5).(4) == 0.0625
    assert Binom.pmf(4, 0.5).(2) == 0.375
    assert Binom.pmf(4, 0.5).(0.9) == 0.0
    assert Binom.pmf(100, 0.2).(20) == 0.09930021480882524
  end

  test "return a cdf " do
    assert Binom.cdf(4, 0.5).(2) == 0.6875
    assert Binom.cdf(100, 0.2).(20) == 0.5594615848734007
  end

  test "get the percentile point value" do
    assert Binom.ppf(10, 0.5).(0.5) == 5.0
    assert Binom.ppf(50, 0.2).(0.6) == 11.0
  end

  test "return a random number from binomial distribution" do
    r = Binom.rand(100, 0.5)
    assert is_float r
    assert r == Math.to_int r
    assert r <= 100
    assert r >= 0
  end

end

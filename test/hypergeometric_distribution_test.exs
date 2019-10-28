defmodule HypergeometricDistributionTest do
  use ExUnit.Case, async: true
  doctest Statistics.Distributions.Hypergeometric, except: [rand: 2]

  alias Statistics.Distributions.Hypergeometric, as: Hyper
  alias Statistics.Math

  test "output of the pmf function" do
    assert Hyper.pmf(52, 5, 26).(2) == 0.3251300520208083
    assert Hyper.pmf(20, 10, 5).(1) == 0.13544891640866874
    assert Hyper.pmf(10, 10, 2).(1) == 0.0
    assert Hyper.pmf(10, 10, 2).(2) == 1.0
  end

  test "return a cdf " do
    assert Hyper.cdf(52, 5, 13).(2) == 0.9072328931572629
    assert Hyper.cdf(80, 50, 23).(10) == 0.02480510161897441
  end

  test "get the percentile point value" do
    assert Hyper.ppf(80, 20, 50).(0.1) == 10.0
    assert Hyper.ppf(70, 10, 30).(0.75) == 5.0
  end

  test "return a random number from hypergeometric distribution" do
    pn = 100
    pk = 5
    n = 10
    r = Hyper.rand(pn, pk, n)
    # will return a float
    assert is_float(r)
    # but it should be an integer
    assert r == Math.to_int(r)
    # cannot be greater than number of trials
    assert r <= n
    # cannot be less than zero
    assert r >= 0
  end
end

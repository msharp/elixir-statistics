defmodule ExponentialDistributionTest do
  use ExUnit.Case, async: true
  doctest Statistics.Distributions.Exponential, except: [rand: 1, rand: 0]

  alias Statistics.Distributions.Exponential


  test "output of the pdf function" do
    assert Exponential.pdf().(-1) == 0
    assert Exponential.pdf(0).(1) == :nan
    assert Exponential.pdf(-1).(1) == :nan
    assert Exponential.pdf().(1) == 0.36787944117144233
    assert Exponential.pdf(3).(2) == 0.0074362565299990755
    assert Exponential.pdf(2).(9) == 3.0459959489425258e-08
  end

  test "return a cdf " do
    assert Exponential.cdf().(-1) == 0
    assert Exponential.cdf(0).(1) == :nan
    assert Exponential.cdf(-1).(1) == :nan
    assert Exponential.cdf().(1) == 0.63212055882855767
    assert Exponential.cdf(3).(2) == 0.9975212478233336
    assert Exponential.cdf(2).(9) == 0.99999998477002028
  end

  test "return a random number from the distribution" do
    assert is_float Exponential.rand(2)
  end

  test "get the percentile point value" do
    assert Exponential.ppf().(-1) == :nan
    assert Exponential.ppf(1).(1.2) == :nan
    assert Exponential.ppf().(0) == 0
    assert Exponential.ppf(1).(1) == :inf
    assert Exponential.ppf(1).(0.5) == 0.6931471805599453
    assert Exponential.ppf(4).(0.9) == 0.57564627324851148
  end

end

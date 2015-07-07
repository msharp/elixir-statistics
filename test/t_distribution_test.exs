defmodule TDistributionTest do
  use ExUnit.Case, async: false
  doctest Statistics.Distributions.T, except: [rand: 0, rand: 3]

  alias Statistics.Distributions.T

  test "output of the pdf function" do
    assert T.pdf(0, 3) == 0.3675525969478612
    assert T.pdf(0.1, 7) ==  0.38279933426055135
    assert T.pdf(0.1, 77) == 0.39564030492250557
  end

  test "return a cdf " do
    assert T.cdf(0, 1) == 0.5
    assert T.cdf(1, 3) == 0.8044988905221144
    assert T.cdf(-1, 2) == 0.21132486540518697
  end

  test "return a random number from the distribution" do
    assert is_float T.rand(2)
    # rands = for _ <- 0..10000, do: T.rand(3)
    #assert T.rand(77) == 0.5
  end

  test "get the percentile point value" do
    assert T.ppf(0.5, 2) == 0.0
    assert T.ppf(0.4, 2) == -0.2889999999999985
  end

end

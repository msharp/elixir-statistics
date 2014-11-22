defmodule TDistributionTest do
  use ExUnit.Case, async: true
  doctest Statistics.Distributions.T, except: [rand: 0, rand: 3]

  alias Statistics.Distributions.T

  test "output of the pdf function" do
    assert T.pdf(0, 3) == 0.36755259694786124
    assert T.pdf(0.1, 7) ==  0.38279933426055135
    assert T.pdf(0.1, 77) == 0.39564030492250557
  end

  test "return a cdf " do
    assert T.cdf(2, 3) == 0.9303369577936188
    assert T.cdf(0, 1) == 0.4999681690117117 # ~ 0.5
  end

  test "return a random number from the distribution" do
    assert is_float T.rand(2) 
    # rands = for _ <- 0..10000, do: T.rand(3)
    #assert T.rand(77) == 0.5
  end

  @tag timeout: 120000
  test "get the percentile point value" do
    assert T.ppf(0.1, 1) == -3.077
  end

end

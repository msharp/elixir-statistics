defmodule TDistributionTest do
  use ExUnit.Case, async: true
  doctest Statistics.Distributions.T, except: [rand: 0, rand: 3]

  alias Statistics.Distributions.T, as: T
  alias Statistics.MathHelpers, as: Math


  test "output of the pdf function" do
    assert T.pdf(0) == 0.0
  end

  test "return a cdf " do
    assert T.cdf(0) == 0.0
  end

  test "return a random number from the distribution" do
    assert is_float T.rand() 
  end

  test "get the percentile point value" do
    assert T.ppf(0.0) == 0.0
  end

end

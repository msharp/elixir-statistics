defmodule ChisqDistributionTest do
  use ExUnit.Case, async: true
  doctest Statistics.Distributions.Chisq, except: [rand: 0, rand: 3]

  alias Statistics.Distributions.Chisq, as: Chisq
  #alias Statistics.MathHelpers, as: Math


  test "output of the pdf function" do
    assert Chisq.pdf(5, 2) == 0.04104249931194938
    assert Chisq.pdf(12, 22) == 0.020651546706168842
  end

  test "return a cdf " do
    assert Chisq.cdf(0) == 0.0
  end

  test "return a random number from the distribution" do
    assert is_float Chisq.rand(2) 
  end

  test "get the percentile point value" do
    assert Chisq.ppf(0.0) == 0.0
  end

end

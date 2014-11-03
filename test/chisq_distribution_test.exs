defmodule ChisqDistributionTest do
  use ExUnit.Case, async: true
  doctest Statistics.Distributions.Chisq, except: [rand: 1]

  alias Statistics.Distributions.Chisq, as: Chisq


  test "output of the pdf function" do
    assert Chisq.pdf(5, 2) == 0.04104249931194938
    assert Chisq.pdf(12, 22) == 0.020651546706168842
  end

  test "return a cdf " do
    assert Chisq.cdf(1, 1) == 0.6826894921370859
    assert Chisq.cdf(2, 2) == 0.6321205588285574
    assert Chisq.cdf(16.8, 23) == 0.18105083862291935
    assert Chisq.cdf(89.999, 77) == 0.8524000316322363
  end

  test "return a random number from the distribution" do
    assert is_float Chisq.rand(2) 
    #rands = for _ <- 0..10000, do: Chisq.rand(1)
    #assert Statistics.mean(rands) == 1
  end

  test "get the percentile point value" do
    assert Chisq.ppf(0.95, 77) == 98.484383459340307
  end

end



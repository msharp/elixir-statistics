defmodule ChisqDistributionTest do
  use ExUnit.Case, async: true
  doctest Statistics.Distributions.Chisq, except: [rand: 1]

  alias Statistics.Distributions.Chisq, as: Chisq

  test "output of the pdf function" do
    assert Chisq.pdf(2).(5) == 0.0410424993119494
    assert Chisq.pdf(22).(12) == 0.020651546706168852
  end

  test "return a cdf " do
    assert Chisq.cdf(1).(1) == 0.6826894921370861
    assert Chisq.cdf(2).(2) == 0.6321205588285578
    assert Chisq.cdf(23).(16.8) == 0.18105083862291943
    assert Chisq.cdf(77).(89.999) == 0.8524000316322364
  end

  test "return a random number from the distribution" do
    assert is_float(Chisq.rand(2))
    # rands = for _ <- 0..10000, do: Chisq.rand(1)
    # assert Statistics.mean(rands) == 1
  end

  test "get the percentile point value" do
    assert Chisq.ppf(77).(0.95) == 98.48438345933911
    assert Chisq.ppf(7).(0.05) == 2.167349909298
  end
end

defmodule BetaDistributionTest do
  use ExUnit.Case, async: true
  doctest Statistics.Distributions.Beta, except: [rand: 2]

  alias Statistics.Distributions.Beta

  test "output of the pdf function" do
    assert Beta.pdf(1, 3).(0.6) == 0.48000000000000054
    assert Beta.pdf(2, 5).(0.2) == 2.457600000000004
    assert Beta.pdf(2, 2).(0.8) == 0.9600000000000015
  end

  test "return a cdf " do
    assert Beta.cdf(1, 1).(0.5) ==  0.4999833333333332
    assert Beta.cdf(2, 10).(0.1) == 0.30264311979999975
    assert Beta.cdf(2, 5).(0.2) == 0.34464000000000033
  end

  test "return a random number from the distribution" do
    assert is_float Beta.rand(1, 2)
  end

  test "get the percentile point value" do
    assert Beta.ppf(1, 2).(0.1) ==  0.05131850509960005
    # the PPF is expensive - don't run all tests every time
    #assert Beta.ppf(2, 5).(0.5) ==  0.26444998329559966
    #assert Beta.ppf(2, 10).(0.9) == 0.3102434478125001
  end

end

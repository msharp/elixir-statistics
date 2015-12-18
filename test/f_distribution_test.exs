defmodule FDistributionTest do
  use ExUnit.Case, async: true
  doctest Statistics.Distributions.F, except: [rand: 2, ppf: 2]

  alias Statistics.Distributions.F

  test "output of the pdf function" do
    assert F.pdf(1,1).(1) == 0.15915494309189537
  end

  test "return a cdf " do
    assert F.cdf(1,1).(1) == 0.4971668763845647
  end

  test "return a random number from the distribution" do
    assert is_float F.rand(1,1)
  end

  test "get the percentile point value" do
    assert F.ppf(1,1).(0.05) == 0.0048621122317455395
  end

end



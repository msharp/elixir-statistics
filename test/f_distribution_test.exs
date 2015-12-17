defmodule FDistributionTest do
  use ExUnit.Case, async: true
  doctest Statistics.Distributions.F, except: [rand: 2]

  alias Statistics.Distributions.F

  test "output of the pdf function" do
    assert F.pdf(1,1).(1) == 0.15915494309189537
  end

  test "return a cdf " do
    assert F.cdf(1,1).(1) == 0.5
  end

  test "return a random number from the distribution" do
    assert is_float F.rand(2,2)
    # rands = for _ <- 0..10000, do: T.rand(3)
    #assert T.rand(77) == 0.5
  end

  @tag timeout: 120000
  test "get the percentile point value" do
    assert F.ppf(1,1).(0.5)  == 1.0
  end

end

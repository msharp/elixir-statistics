defmodule NormalDistributionTest do
  use ExUnit.Case, async: true
  doctest Statistics.Distributions.Normal

  alias Statistics.Distributions.Normal, as: N

  test "return a pmf function" do
    assert N.pmf == 0.0
  end

  test "return a cdf function" do
    assert N.cdf == 0.0
  end

  test "return a normally-distributed random number" do
    assert N.rnd == 0.0
  end

end

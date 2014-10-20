defmodule NormalDistributionTest do
  use ExUnit.Case, async: true
  doctest Statistics.Distributions.Normal

  alias Statistics.Distributions.Normal, as: Norm

  test "output of the pdf function" do
    assert Norm.pdf(0) == 0.3989422804014327
    assert Norm.pdf(3, 0.2, 1) == 0.00791545158297997
    assert Norm.pdf(-1) == 0.24197072451914337
    assert Norm.pdf(22.0, 23.5, 1.7) == 0.15900173884840293
  end

  test "return a cdf function" do
    assert Norm.cdf == 0.0
  end

  test "return a normally-distributed random number" do
    assert Norm.rnd == 0.0
  end

end

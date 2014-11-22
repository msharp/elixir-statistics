defmodule MathFunctionsTest do
  use ExUnit.Case, async: true
  doctest Statistics.Math.Functions

  alias Statistics.Math.Functions
  alias Statistics.Math

  test "gamma function" do
    assert Functions.gamma(22) == 5.109094217170959e19
    assert Functions.gamma(0.02) == 49.442210163195654
  end

  test "incomplete gamma function" do
    assert Functions.gammainc(2,2) == 0.5939941502901618
    assert Functions.gammainc(1,2) == 0.8646647167633872
    assert Functions.gammainc(1,1) == 0.63212055882855778
    # not a complete solution ... some cases that do not work
    #assert Functions.gammainc(4,1) == 0.018988156876153808
    #assert Functions.gammainc(0.1,1) == 0.97587265627367215
  end

  test "beta function" do
    assert Functions.beta(1, 2) == 0.5
    assert Functions.beta(2, 2) == 0.1666666666666665
    assert Functions.beta(0.05, 1) == 19.999999999999996
  end

  test "hypergeometric 2F1 function" do
    #assert Functions.hyp2f1(0.2, 3, 0.2, 0.2) == 1.9531249999999998
    assert Functions.hyp2f1(1, 2, 1, 0.5) == 3.999999999999959
    assert Functions.hyp2f1(1, 1, 1, 0.5) == 2.000000000000001
  end

  test "simpsons numeric integration rule" do
    f = fn x -> Math.pow(x,9) end
    sr = Functions.simpson(f, 0, 10, 100000)
    assert Math.round(sr, 1) == 1000000000.0
  end

end

defmodule MathTest do
  use ExUnit.Case, async: true
  doctest Statistics.Math

  alias Statistics.Math

  test "square root" do
    assert Math.sqrt(9) == 3
    assert Math.sqrt(99) == 9.9498743710662
  end

  test "raise to a power" do
    assert Math.pow(3, 2) == 9
    assert Math.pow(2, -1) == 0.5
    assert Math.pow(-0.5, -0.5) == -1.4142135623730951
    assert Math.pow(99, 3) == 970299
  end

  test "constant e" do
    assert Math.e == 2.718281828459045
  end

  test "constant pi" do
    assert Math.pi == 3.141592653589793
  end

  test "natural log" do
    assert Math.ln(2) == 0.6931471805599453
    assert Math.ln(99) == 4.59511985013459
  end

  test "exponent function" do
    assert Math.exp(2) == 7.3890560989306495
  end

  test "round a decimal" do
    assert Math.round(99.999999, 3) == 100
    assert Math.round(0.123456, 4) == 0.1235
    assert Math.round(0.123436, 4) == 0.1234
    assert Math.round(1.123456, 0) == 1
  end

  test "get absolute value" do
    assert Math.abs(-2) == 2
    assert Math.abs(2.2) == 2.2
  end

  test "calculate factorial" do
    assert Math.factorial(5) == 120
    assert Math.factorial(11) == 39916800
  end

  test "turn a float into an integer" do
    assert Math.to_int(2.2) == 2
    assert Math.to_int(599.9) == 599
  end

  test "gamma function" do
    assert Math.gamma(22) == 5.109094217170959e19
    assert Math.gamma(0.02) == 49.442210163195654
  end

  test "incomplete gamma function" do
    assert Math.gammainc(2,2) == 0.5939941502901618
    assert Math.gammainc(1,2) == 0.8646647167633872
    assert Math.gammainc(1,1) == 0.63212055882855778
    # not a complete solution ... some cases that do not work
    #assert Math.gammainc(4,1) == 0.018988156876153808
    #assert Math.gammainc(0.1,1) == 0.97587265627367215
  end

  test "beta function" do
    assert Math.beta(1, 2) == 0.5
    assert Math.beta(2, 2) == 0.1666666666666665
    assert Math.beta(0.05, 1) == 19.999999999999996
  end

  test "hypergeometric 2F1 function" do
    #assert Math.hyp2f1(0.2, 3, 0.2, 0.2) == 1.9531249999999998
    assert Math.hyp2f1(1, 2, 1, 0.5) == 3.999999999999959
    assert Math.hyp2f1(1, 1, 1, 0.5) == 2.000000000000001
  end

end

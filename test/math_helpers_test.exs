defmodule MathHelpersTest do
  use ExUnit.Case, async: true
  doctest Statistics.MathHelpers

  alias Statistics.MathHelpers, as: Math

  test "square root" do
    assert Math.sqrt(9) == 3
    assert Math.sqrt(99) == 9.9498743710662
  end

  test "raise to a power" do
    assert Math.pow(3, 2) == 9
    assert Math.pow(2, -1) == 0.5
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

end

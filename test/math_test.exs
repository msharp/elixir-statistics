defmodule MathTest do
  use ExUnit.Case

  test "sum a list" do
    assert Math.sum([1,2,3,4,5,6,7,8,9]) == 45
  end

  test "calculate mean" do
    assert Math.mean([1]) == 1
    assert Math.mean([1,2,3,4,5,6,7,8,9]) == 5
  end

  test "calculate median" do
    assert Math.median([1,2,3,4,5,6,7,8,9]) == 5
    assert Math.median([1,2,3,4,5,6,7,8]) == 4.5
  end

  test "calculate square root" do
    assert Math.sqrt(64) == 8
  end

  test "calculate variance" do
    assert Math.variance([4,3,3,4,5,6,7,6,5]) == 1.7283950617283952
  end

  test "calculate standard deviation" do
    assert Math.stdev([4,3,3,4,5,6,7,6,5]) == 1.314684396244359
  end

end

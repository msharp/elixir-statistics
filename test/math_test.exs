defmodule MathTest do
  use ExUnit.Case

  test "sum a list" do
    assert Math.sum([1,2,3,4,5,6,7,8,9]) == 45
  end

  test "calculate mean" do
    assert Math.mean([1]) == 1
    assert Math.mean([1,2,3,4,5,6,7,8,9]) == 5
  end

end

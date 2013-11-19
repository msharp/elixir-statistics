defmodule StatisticsTest do
  use ExUnit.Case

  test "sum a list" do
    assert Statistics.sum([1,2,3,4,5,6,7,8,9]) == 45
  end

  test "calculate mean" do
    assert Statistics.mean([1]) == 1
    assert Statistics.mean([1,2,3,4,5,6,7,8,9]) == 5
  end

  test "calculate median" do
    assert Statistics.median([1,2,3,4,5,6,7,8,9]) == 5
    assert Statistics.median([1,2,3,4,5,6,7,8]) == 4.5
  end

  test "get maximum" do
    assert Statistics.max([2,4,3,5,4,6,99,1,7,3,6]) == 99
  end

  test "get minimum" do
    assert Statistics.min([23,45,34,53,44,65,99,1,74,32,69]) == 1
  end

  test "get first quartile point" do
    assert Statistics.quartile([1,2,3,4,5,5,6,7,8,9],:first) == 3
    assert Statistics.quartile([1,2,3,4,5,6,7,8,9],:first) == 3
  end

  test "get third quartile point" do
    assert Statistics.quartile([1,2,3,4,5,5,6,7,8,9],:third) == 7
    assert Statistics.quartile([1,2,3,4,5,6,7,8,9],:third) == 7
  end

  test "get range" do
    assert Statistics.range([1,2,3,4,5,6,7,8,9]) == 8
  end

  test "get inter-quartile range" do
    assert Statistics.iqr([1,2,3,4,5,6,7,8,9]) == 4
  end


  test "calculate square root" do
    assert Statistics.sqrt(64) == 8
  end

  test "calculate variance" do
    assert Statistics.variance([4,3,3,4,5,6,7,6,5]) == 1.7283950617283952
  end

  test "calculate standard deviation" do
    assert Statistics.stdev([4,3,3,4,5,6,7,6,5]) == 1.314684396244359
  end

end

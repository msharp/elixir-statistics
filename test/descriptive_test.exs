defmodule DescriptiveTest do
  use ExUnit.Case

  test "sum a list" do
    assert Statistics.Descriptive.sum([1,2,3,4,5,6,7,8,9]) == 45
  end

  test "calculate mean" do
    assert Statistics.Descriptive.mean([1]) == 1
    assert Statistics.Descriptive.mean([1,2,3,4,5,6,7,8,9]) == 5
  end

  test "get mode" do 
    assert Statistics.Descriptive.mode([1,2,3,2,4,5,2,6,7,2,8,9]) == 2
  end

  test "calculate median" do
    assert Statistics.Descriptive.median([1,2,3,4,5,6,7,8,9]) == 5
    assert Statistics.Descriptive.median([1,2,3,4,5,6,7,8]) == 4.5
  end

  test "get maximum" do
    assert Statistics.Descriptive.max([2,4,3,5,4,6,99,1,7,3,6]) == 99
  end

  test "get minimum" do
    assert Statistics.Descriptive.min([23,45,34,53,44,65,99,1,74,32,69]) == 1
  end

  test "get first quartile point" do
    assert Statistics.Descriptive.quartile([1,2,3,4,5,5,6,7,8,9],:first) == 3
    assert Statistics.Descriptive.quartile([1,2,3,4,5,6,7,8,9],:first) == 3
  end

  test "get third quartile point" do
    assert Statistics.Descriptive.quartile([1,2,3,4,5,5,6,7,8,9],:third) == 7
    assert Statistics.Descriptive.quartile([1,2,3,4,5,6,7,8,9],:third) == 7
  end

  test "get range" do
    assert Statistics.Descriptive.range([1,2,3,4,5,6,7,8,9]) == 8
  end

  test "get inter-quartile range" do
    assert Statistics.Descriptive.iqr([1,2,3,4,5,6,7,8,9]) == 4
  end


  test "calculate square root" do
    assert Statistics.Descriptive.sqrt(64) == 8
  end

  test "calculate variance" do
    assert Statistics.Descriptive.variance([4,3,3,4,5,6,7,6,5]) == 1.7283950617283952
  end

  test "calculate standard deviation" do
    assert Statistics.Descriptive.stdev([4,3,3,4,5,6,7,6,5]) == 1.314684396244359
  end

  test "calculate trimmed mean" do 
    assert Statistics.Descriptive.trimmed_mean([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]) == 8.0 # not trimmed
    assert Statistics.Descriptive.trimmed_mean([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15], {4,9}) == 6.5
    assert Statistics.Descriptive.trimmed_mean([1,2,3,4,5,5,6,6,7,7,8,8,10,11,12,13,14,15],:iqr) == 7.3
  end

  # moment/skew/kurtosis numbers match python/scipy

  test "calculate moment about the mean" do
    a = [1,2,3,4,5,6,7,8,9,8,7,6,5,4,3]
    assert Statistics.Descriptive.moment(a,1) == 0.0
    assert Statistics.Descriptive.moment(a,2) == 5.2266666666666675 
    assert Statistics.Descriptive.moment(a,3) == -1.3440000000000025
  end

  test "calculate skewness" do
    assert Statistics.Descriptive.skew([1,2,3,2,1]) == 0.3436215967445454
  end

  test "calculate kurtosis (fisher)" do
    assert Statistics.Descriptive.kurtosis([1,2,3,2,1]) == -1.1530612244897964
  end

end

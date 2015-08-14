defmodule DescriptiveTest do
  use ExUnit.Case, async: true
  doctest Statistics

  test "sum a list" do
    assert Statistics.sum([1,2,3,4,5,6,7,8,9]) == 45
  end

  test "calculate mean" do
    assert Statistics.mean([]) == nil
    assert Statistics.mean([1]) == 1
    assert Statistics.mean([1,2,3,4,5,6,7,8,9]) == 5
  end

  test "get mode" do
    assert Statistics.mode([]) == nil
    assert Statistics.mode([1,2,3,2,4,5,2,6,7,2,8,9]) == 2
  end

  test "calculate median" do
    assert Statistics.median([]) == nil
    assert Statistics.median([1,2,3,4,5,6,7,8,9]) == 5
    assert Statistics.median([1,2,3,4,5,6,7,8]) == 4.5
  end

  test "get maximum" do
    assert Statistics.max([]) == nil
    assert Statistics.max([2,4,3,5,4,6,99,1,7,3,6]) == 99
  end

  test "get minimum" do
    assert Statistics.min([]) == nil
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

  test "get nth percentile score" do
    a = [1,2,3,4,5,6,7,8,9]
    assert Statistics.percentile(a,0) == 1
    assert Statistics.percentile(a,20) == 2.6
    assert Statistics.percentile(a,80) == 7.4
    assert Statistics.percentile(a,100) == 9
  end

  test "get range" do
    assert Statistics.range([1,2,3,4,5,6,7,8,9]) == 8
  end

  test "get inter-quartile range" do
    assert Statistics.iqr([1,2,3,4,5,6,7,8,9]) == 4
  end

  test "calculate variance" do
    assert Statistics.variance([4,3,3,4,5,6,7,6,5]) == 1.7283950617283952
  end

  test "calculate standard deviation" do
    assert Statistics.stdev([4,3,3,4,5,6,7,6,5]) == 1.314684396244359
  end

  test "calculate trimmed mean" do
    assert Statistics.trimmed_mean([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15], {4,9}) == 6.5
    assert Statistics.trimmed_mean([1,2,3,4,5,5,6,6,7,7,8,8,10,11,12,13,14,15],:iqr) == 7.3
  end

  test "calculate harmonic mean" do
    assert Statistics.harmonic_mean([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]) == 4.5204836768674568
  end

  test "calculate geometric mean" do
    assert Statistics.geometric_mean([1,2,3,4,5,6]) == 2.9937951655239088
  end

  # moment/skew/kurtosis numbers match python/scipy

  test "calculate moment about the mean" do
    a = [1,2,3,4,5,6,7,8,9,8,7,6,5,4,3]
    assert Statistics.moment(a,1) == 0.0
    assert Statistics.moment(a,2) == 5.2266666666666675
    assert Statistics.moment(a,3) == -1.3440000000000025
  end

  test "calculate skewness" do
    assert Statistics.skew([1,2,3,2,1]) == 0.3436215967445454
  end

  test "calculate kurtosis (fisher)" do
    assert Statistics.kurtosis([1,2,3,2,1]) == -1.1530612244897964
  end

  test "calculate standard score for items in a list" do
    expected =  [-0.7427813527082074, -1.5784103745049407, -0.7427813527082074,
                  0.09284766908852597, 0.9284766908852594, 1.7641057126819928,
                  0.9284766908852594, 0.09284766908852597, -0.7427813527082074]
    assert Statistics.zscore([3,2,3,4,5,6,5,4,3]) == expected
  end

  test "calculate the correlation of 2 lists" do
    x = [1,2,3,4,12,4,2,4,6,3,5,6,7,4,7,8,2,5]
    y = [1,3,5,6,5,2,7,4,6,8,2,3,9,5,2,8,9,4]
    assert Statistics.correlation(x, y) ==  0.09315273948675289
    assert_raise ArgumentError, fn() -> Statistics.correlation(x, []) end
  end

  test "calculate the covariance of 2 lists" do
    x = [1,2,3,4,12,4,2,4,6,3,5,6,7,4,7,8,2,5]
    y = [1,3,5,6,5,2,7,4,6,8,2,3,9,5,2,8,9,4]
    assert Statistics.covariance(x, y) == 0.6307189542483661
    assert_raise ArgumentError, fn() -> Statistics.covariance(x, []) end
  end

end

defmodule DescriptiveTest do
  use ExUnit.Case, async: true
  doctest Statistics

  @null []

  @a Enum.to_list(1..9)
  @b [4, 3, 3, 4, 5, 6, 7, 6, 5]
  @c Enum.to_list(1..15)
  @d @a ++ [8, 7, 6, 5, 4, 3]
  @e [1, 2, 3, 2, 1]
  @f Enum.to_list(1..6)
  @g [1]

  @x [1, 2, 3, 4, 12, 4, 2, 4, 6, 3, 5, 6, 7, 4, 7, 8, 2, 5]
  @y [1, 3, 5, 6, 5, 2, 7, 4, 6, 8, 2, 3, 9, 5, 2, 8, 9, 4]

  test "sum a list" do
    assert Statistics.sum(@a) == 45
  end

  test "calculate mean" do
    assert Statistics.mean(@null) == nil
    assert Statistics.mean([1]) == 1
    assert Statistics.mean(@a) == 5
  end

  test "get mode" do
    assert Statistics.mode(@null) == nil
    assert Statistics.mode(@a ++ [2, 2]) == 2
  end

  test "calculate median" do
    assert Statistics.median(@null) == nil
    assert Statistics.median(@a) == 5
    assert Statistics.median(@a -- [9]) == 4.5
  end

  test "get maximum" do
    assert Statistics.max(@null) == nil
    assert Statistics.max(@a ++ [99]) == 99
  end

  test "get minimum" do
    assert Statistics.min(@null) == nil
    assert Statistics.min([23, 45, 34, 53, 44, 65, 99, 1, 74, 32, 69]) == 1
  end

  test "get first quartile point" do
    assert Statistics.quartile(@a ++ [5], :first) == 3
    assert Statistics.quartile(@a, :first) == 3
  end

  test "get third quartile point" do
    assert Statistics.quartile(@a ++ [5], :third) == 7
    assert Statistics.quartile(@a, :third) == 7
  end

  test "get nth percentile score" do
    assert Statistics.percentile(@null, 12) == nil

    assert Statistics.percentile(@a, 0) == 1
    assert Statistics.percentile(@a, 20) == 2.6
    assert Statistics.percentile(@a, 80) == 7.4
    assert Statistics.percentile(@a, 100) == 9
    assert Statistics.percentile(@g, 50) == 1
  end

  test "get range" do
    assert Statistics.range(@null) == nil
    assert Statistics.range(@a) == 8
  end

  test "get inter-quartile range" do
    assert Statistics.iqr(@null) == nil
    assert Statistics.iqr(@a) == 4
  end

  test "calculate variance" do
    assert Statistics.variance(@null) == nil
    assert Statistics.variance(@b) == 1.7283949851989746
  end

  test "calculate standard deviation" do
    assert Statistics.stdev(@null) == nil
    assert Statistics.stdev(@b) == 1.3146843910217285
  end

  test "calculate trimmed mean" do
    assert Statistics.trimmed_mean(@null, {1, 4}) == nil
    assert Statistics.trimmed_mean(@c, {4, 9}) == 6.5
    assert Statistics.trimmed_mean((@c ++ [5, 6, 7, 8]) -- [9], :iqr) == 7.300000190734863
  end

  test "calculate harmonic mean" do
    assert Statistics.harmonic_mean(@null) == nil
    assert Statistics.harmonic_mean(@c) == 4.5204836768674568
  end

  test "calculate geometric mean" do
    assert Statistics.geometric_mean(@null) == nil
    assert Statistics.geometric_mean(@f) == 2.9937951655239088
  end

  # moment/skew/kurtosis numbers match python/scipy

  test "calculate moment about the mean" do
    assert Statistics.moment(@null, 3) == nil

    assert Statistics.moment(@d, 1) == 0.0
    assert Statistics.moment(@d, 2) == 5.2266669273376465
    assert Statistics.moment(@d, 3) == -1.3439967632293701
  end

  test "calculate skewness" do
    assert Statistics.skew(@null) == nil
    assert Statistics.skew(@e) == 0.3436217931063174
  end

  test "calculate kurtosis (fisher)" do
    assert Statistics.kurtosis(@null) == nil
    assert Statistics.kurtosis(@e) == -1.1530611465519447
  end

  test "calculate standard score for items in a list" do
    expected = [
      -0.7427812933479767,
      -1.5784102981718204,
      -0.7427812933479767,
      0.09284771147586708,
      0.9284767162997108,
      1.7641057211235547,
      0.9284767162997108,
      0.09284771147586708,
      -0.7427812933479767
    ]

    assert Statistics.zscore([3, 2, 3, 4, 5, 6, 5, 4, 3]) == expected
  end

  test "calculate the correlation of 2 lists" do
    assert Statistics.correlation(@x, @y) == 0.09315274811885829
    assert_raise FunctionClauseError, fn -> Statistics.correlation(@x, @null) end
  end

  test "calculate the covariance of 2 lists" do
    assert Statistics.covariance(@x, @y) == 0.630719006061554
    assert_raise FunctionClauseError, fn -> Statistics.covariance(@x, @null) end
  end
end

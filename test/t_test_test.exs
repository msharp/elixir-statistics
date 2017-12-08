defmodule TTestTest do
  use ExUnit.Case, async: true
  doctest Statistics.Tests.TTest

  alias Statistics.Tests.TTest

  test "one sample t-test" do
    assert TTest.one_sample([1,2,1,2,1,2],1.5) == %{p: 1.0, t: 0.0}
    assert TTest.one_sample([4,1,2,3,1,2,3,4],2) == %{p: 0.23032680249555892, t: 1.2649110640673518}
  end

  test "independent samples t-test" do
    assert TTest.ind_samples([1,2,1,2,1,2],[2,1,2,1,2,1]) == %{t: 0.0, p: 1.0} 
    assert TTest.ind_samples([1,2,1,2,1,2],[5,6,7,6,7,5]) == %{p: 4.3244470028110745e-7, t: -11.512838683202965}
  end
end

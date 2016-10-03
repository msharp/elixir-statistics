defmodule TTestTest do
  use ExUnit.Case, async: true
  doctest Statistics.Tests.TTest

  alias Statistics.Tests.TTest

  test "one sample t test" do
    assert TTest.one_sample([4,1,2,3,1,2,3,4],2) == %{p: 0.23032680249555892, t: 1.2649110640673518}
  end

end

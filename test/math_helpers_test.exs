defmodule MathHelpersTest do
  use ExUnit.Case, async: true
  doctest Statistics.MathHelpers

  import Statistics.MathHelpers
  alias Statistics.MathHelpers, as: Math

  test "exponent function" do
    assert Math.exp(2) == 7.3890560989306495
  end

end

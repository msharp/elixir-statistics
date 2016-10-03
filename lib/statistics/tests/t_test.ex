defmodule Statistics.Tests.TTest do

  import Statistics
  import Statistics.Math
  alias Statistics.Distributions.T

  @moduledoc """
  Student's t test
  
  """
  
  @doc """
  A two-sided test for the null hypothesis that the 
  expected value (mean) of a sample of independent
  observations a is equal to the given population mean, `popmean`.

  Returns the _t_ statistic, and the _p_ value.

  ## Example

      iex> Statistics.Tests.TTest.one_sample([1,2,3,2,1], 3)
      %{p: 0.023206570788795993, t: -3.585685828003181}

  """
  def one_sample(list, popmean) do
    df = length(list)-1
    t = (mean(list) - popmean) / (stdev(list) / sqrt(length(list)))
    c = T.cdf(df).(t) 
    p1 = case t < 0.0 do 
      true -> c
      false -> 1 - c
    end
    p = 2 * p1 # two-sided test
    %{t: t, p: p}
  end


end

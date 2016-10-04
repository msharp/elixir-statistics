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
    p = get_t_prob(t, df)
    %{t: t, p: p}
  end

 
  @doc """
  A two-sided test for the null hypothesis that the 
  mean of `list1` is different to the mean of `list2`.

  The variance of the lists should be equal but the 
  sample size of each last can be different.

  Returns the _t_ statistic, and the _p_ value.

  ## Example

      iex> Statistics.Tests.TTest.ind_samples([1,2,3,2,1], [3,2,4,3,5])
      %{p: 0.022802155958137702, t: -2.82842712474619}

      iex> Statistics.Tests.TTest.ind_samples([1,2,3,2,1], [3,2,4,3,5,4,5,6])
      %{p: 0.0044530673387188, t: -3.5858542135407596}

  """
  def ind_samples(list1, list2) do
    df = length(list1) + length(list2) - 2
    mu1 = mean(list1)
    mu2 = mean(list2)
    # calculate pooled standard deviation and
    # sample proportion differently when 
    # sample sizes are unequal
    {sp, sz} = case length(list1) == length(list2) do
      true ->
        spt = sqrt((variance(list1) + variance(list2)) / 2)
        szt = sqrt(2/length(list1))
        {spt, szt}
      false ->
        # weight variances by sample size
        adj_var1 = (length(list1)-1) * variance(list1)
        adj_var2 = (length(list2)-1) * variance(list2)
        spf = sqrt((adj_var1 + adj_var2) / df)
        szf = sqrt((1 / length(list1)) + (1 / length(list2)))
        {spf, szf}
    end
    t = (mu1 - mu2) / (sp * sz)
    p = get_t_prob(t, df)
    %{t: t, p: p}
  end


  defp get_t_prob(t, df) do
    c = T.cdf(df).(t) 
    p = case t < 0.0 do 
      true -> c
      false -> 1 - c
    end
    case p < 0.5 do # two-sided test
      true -> 2 * p
      false -> 1.0
    end
  end

end

defmodule Statistics.Distributions.Normal do
  #use Application.Behaviour

  import Statistics.MathHelpers
  alias Statistics.MathHelpers, as: M

  @doc """
  Probability density function
  
  get result of probability density function

  ## Examples
  
      iex> Statistics.Distributions.Normal.pdf(0) 
      0.3989422804014327
      iex> Statistics.Distributions.Normal.pdf(1.3, 0.2, 1)
      0.21785217703255055

  """
  def pdf(x) do
    pdf(x, 0, 1)
  end

  def pdf(x, mu, sigma) do
    numexp = M.pow((x - mu), 2) / (2 * M.pow(sigma, 2))
    denom = sigma * M.sqrt((2 * M.pi))
    numer = M.pow(M.e, (numexp * -1)) 
    numer / denom
  end

  def cdf do
    0.0
  end

    def rnd do 
      0.0
    end

end

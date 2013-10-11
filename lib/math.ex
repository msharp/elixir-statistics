defmodule Math do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Math.Supervisor.start_link
  end

  @moduledoc """
  Provides som helpful mathematical functions
  """
  
  @doc """
  Sum the contents of a list

  ## Examples

    iex> Math.sum([1,2,3])
    6
  """
  def sum(list) do
    List.foldl(list, 0, fn (x, acc) -> x + acc end)
  end

  @doc """
  Calculate the mean from a list of numbers

  ## Examples
    
    iex> Math.mean([1,2,3])
    2
  """
  def mean(list) do
    sum(list) / Enum.count(list)
  end


end

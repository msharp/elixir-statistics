defmodule Statistics.Math.Equalish do
  defmacro __using__(_) do
    quote do
      import Kernel, except: [{:==, 2}]
      import unquote(__MODULE__)
      import Statistics.Math
    end
  end

  defmacro left == right do
    precision = 6
    quote do
      Statistics.Math.round(unquote(left), unquote(precision)) == Statistics.Math.round(unquote(right), unquote(precision))
    end
  end

end

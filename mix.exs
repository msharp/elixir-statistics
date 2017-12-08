defmodule Statistics.Mixfile do
  use Mix.Project

  @version "0.5.0"

  def project do
    [ app: :statistics,
      version: @version,
      elixir: ">= 1.1.0",
      description: description(),
      package: package(),
      deps: deps() ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    """
    Functions for descriptive statistics and common distributions
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Max Sharples", "Kash Nouroozi"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/msharp/elixir-statistics"}
    ]
  end

end

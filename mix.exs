defmodule Statistics.Mixfile do
  use Mix.Project

  def project do
    [ app: :statistics,
      version: File.read!("VERSION") |> String.strip,
      elixir: "~> 1.0.0",
      description: description,
      package: package,
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [mod: { Statistics, [] }]
  end

  defp deps do
    [
      { :ex_doc, "~> 0.6.0" },
      {:earmark, ">= 0.0.0"}
    ]
  end

  defp description do
    """
    A set of statistics functions
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*", "VERSION"],
      contributors: ["Max Sharples"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/msharp/elixir-statistics"}
    ]
  end

end

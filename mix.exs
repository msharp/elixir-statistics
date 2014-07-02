defmodule Statistics.Mixfile do
  use Mix.Project

  def project do
    [ app: :statistics,
      version: File.read!("VERSION") |> String.strip,
      elixir: "~> 0.14.2",
      description: description,
      package: package,
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [mod: { Statistics, [] }]
  end

  defp deps do
     [ { :ex_doc, github: "elixir-lang/ex_doc"} ]
  end

  defp description do
    """
    A set of statistics functions
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      contributors: ["Max Sharples"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/msharp/elixir-statistics"}
    ]
  end

end

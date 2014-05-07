defmodule Statistics.Mixfile do
  use Mix.Project

  def project do
    [ app: :statistics,
      version: File.read!("VERSION") |> String.strip,
      elixir: "~> 0.13.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [mod: { Statistics, [] }]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
     [ { :ex_doc, github: "elixir-lang/ex_doc" } ]
  end
end

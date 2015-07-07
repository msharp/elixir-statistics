
defmodule Mix.Tasks.Compile.Cephes do
  @shortdoc "Compiles Cephes"
  def run(_) do
    {result, _error_code} = System.cmd("make", ["priv/cmath.so"], stderr_to_stdout: true)
    Mix.shell.info result
    :ok
  end
end

defmodule Statistics.Mixfile do
  use Mix.Project

  def project do
    [ app: :statistics,
      version: File.read!("VERSION") |> String.strip,
      elixir: "~> 1.0.0",
      description: description,
      package: package,
      deps: deps,
      compilers: [:cephes, :elixir, :app]
      ]
  end

  # Configuration for the OTP application
  def application do
    [mod: { Statistics, [] }]
  end

  defp deps do
    [
      { :ex_doc, "~> 0.6.0", only: :dev },
      { :earmark, ">= 0.0.0", only: :dev },
      { :cephes, github: "msharp/cephes-math", app: false}
    ]
  end

  defp description do
    """
    A set of statistics functions
    """
  end

  defp package do
    [
      files: [
          "lib", 
          "mix.exs", 
          "README*", 
          "LICENSE*", 
          "VERSION",
          "src",
          "priv"
          ],
      contributors: ["Max Sharples"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/msharp/elixir-statistics"}
    ]
  end

end

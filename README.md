#  Statistics

[![Build Status](https://travis-ci.org/msharp/elixir-statistics.svg?branch=master)](https://travis-ci.org/msharp/elixir-statistics)
[![hex.pm version](https://img.shields.io/hexpm/v/statistics.svg?style=flat)](https://hex.pm/packages/statistics)

Statistics functions and distributions for [Elixir](https://github.com/elixir-lang/elixir).

## Usage

Add Statistics as a dependency in your `mix.exs` file to install from [hex.pm](https://hex.pm).

```elixir
def deps do
  [
    { :statistics, "~> 0.4.0"}
  ]
end
```

After you are done, run `mix deps.get` in your shell to fetch and compile Statistics.

To try it out, start an interactive Elixir shell with `iex -S mix`.

Get the median value from a list

```
iex> Statistics.median([1,2,3])
2
```

Calculate the variance of a list of values.

```
iex> Statistics.variance([1,2,3,4])
1.25
```

Or draw a random number from a Gaussian distribution with a mean of 1 and standard deviation of 2.

```
iex> Statistics.Distributions.Normal.rand(1, 2)
2.5998185179627384
```

## Documentation

Elixir has great documentation tools using `ex_doc`.

The docs are hosted on [hexdocs.pm/statistics](http://hexdocs.pm/statistics/).

## Performance

This is not a library to use if you need fast computation.

Everything is implemented in Elixir. Many of the implementations use slow approximations, numerical function integration, or trial-and-error methods.

There is much room for improvement. To make this library really fast (and precise), we would probably need to interface with existing C libraries.

## Roadmap

This library is evolving.

I plan to add common statistical tests and most common distributions.

## Contributing

I will accept pull requests.

If you want to contribute, please create a topic branch with tests.

## License

Apache 2

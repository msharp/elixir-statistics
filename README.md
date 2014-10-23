#  Statistics
 
[![Build Status](https://travis-ci.org/msharp/elixir-statistics.svg?branch=master)](https://travis-ci.org/msharp/elixir-statistics)
[![hex.pm version](https://img.shields.io/hexpm/v/statistics.svg?style=flat)](https://hex.pm/packages/statistics)

Statistics functions for [Elixir](https://github.com/elixir-lang/elixir).

## Usage 

Add Statistics as a dependency in your `mix.exs` file to install from [hex.pm](https://hex.pm).

```elixir
def deps do
  [ 
    { :statistics, "~> 0.2.0"} 
  ]
end
```
  
After you are done, run `mix deps.get` in your shell to fetch and compile Statistics. 

To try it out, start an interactive Elixir shell with `iex -S mix`.

```iex
iex> alias Statistics, as: Stats
nil
iex> Stats.median([1,2,3])
2
iex> Stats.variance([1,2,3,4])
1.25
```

## Roadmap

This library is evolving to include more than just simple descriptive statistics. 

I plan to add most common statistical tests and distributions.

## Contributing

I'd love to accept pull requests. 

If you want to contribute, please create a topic branch with tests.

## License

Apache 2


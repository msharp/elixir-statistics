#  Statistics

Statistics functions for [Elixir](https://github.com/elixir-lang/elixir).

## Usage 

Add Statistics as a dependency in your `mix.exs` file.

```elixir
def deps do
[ { :statistics, github: "msharp/elixir-statistics" } ]
end
```
  
After you are done, run `mix deps.get` in your shell to fetch and compile Statistics. 

iTo try it out, start an interactive Elixir shell with `iex -S mix`.

```iex
iex> alias Statistics, as: S
nil
iex> S.Descriptive.median([1,2,3])
2
iex> S.Descriptive.variance([1,2,3,4])
1.25
```

## Roadmap

This library is currently mostly only descriptive statistics. But I'm planning to add common statistical tests and distributions.


## Contributing

Happy to accept pull requests. Please create a topic branch with tests.

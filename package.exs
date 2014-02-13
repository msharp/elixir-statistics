Expm.Package.new(
    name: "statistics", 
    description: "General statistical functions",
    keywords: ["statistics","stats"], 
    version: File.read!("VERSION") |> String.strip,
    licenses: [[name: "MIT"]],
    maintainers: [[name: "Max Sharples", email: "maxsharples@gmail.com"]],
    repositories: [[github: "msharp/elixir-statistics"]]
)

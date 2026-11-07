```julia
setprotocol!(;
    domain::AbstractString = "github.com",
    protocol::Union{Nothing, AbstractString}=nothing
)
```

ホストされているパッケージへのアクセスに使用するプロトコルを設定します。URLを`add`したり、パッケージを`develop`したりする際に使用されます。デフォルトでは、選択はパッケージ開発者に委ねられます（`protocol === nothing`）。`protocol`には、`"https"`または`"git"`も指定できます。

# Examples

```julia-repl
julia> Pkg.setprotocol!(domain = "github.com", protocol = "ssh")

# Use HTTPS for GitHub (default, good for most users)
julia> Pkg.setprotocol!(domain = "github.com", protocol = "https")

# Reset to default (let package developer decide)
julia> Pkg.setprotocol!(domain = "github.com", protocol = nothing)

# Set protocol for custom domain without specifying protocol
julia> Pkg.setprotocol!(domain = "gitlab.mycompany.com")

# Use Git protocol for a custom domain
julia> Pkg.setprotocol!(domain = "gitlab.mycompany.com", protocol = "git")
```

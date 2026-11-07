```julia
setprotocol!(;
    domain::AbstractString = "github.com",
    protocol::Union{Nothing, AbstractString}=nothing
)
```

URL の `add` またはパッケージの `develop` 時に、ホストされたパッケージへのアクセスに使用するプロトコルを設定します。デフォルトでは、選択をパッケージ開発者に委ねます（`protocol === nothing`）。`protocol` のその他の選択肢は、`"https"` または `"git"` です。

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

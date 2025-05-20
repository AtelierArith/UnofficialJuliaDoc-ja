```
setprotocol!(;
    domain::AbstractString = "github.com",
    protocol::Union{Nothing, AbstractString}=nothing
)

ホストされたパッケージにアクセスするために使用されるプロトコルを設定します。URLを`add`したり、パッケージを`develop`したりする際に使用されます。デフォルトでは、パッケージ開発者に選択を委ねます（`protocol === nothing`）。`protocol`の他の選択肢は`"https"`または`"git"`です。

# 例

```

julia-repl julia> Pkg.setprotocol!(domain = "github.com", protocol = "ssh")

julia> Pkg.setprotocol!(domain = "gitlab.mycompany.com") ```

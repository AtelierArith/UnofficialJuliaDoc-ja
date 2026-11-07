```julia
readonly([state::Bool], [ctx::Context])
```

現在の環境の読み取り専用状態を取得または設定します。

# Examples

```julia-repl
julia> Pkg.readonly()  # check current readonly state
false

julia> Pkg.readonly(true)  # enable readonly mode
false  # returns previous state

julia> Pkg.readonly()
true

julia> Pkg.readonly(false)  # disable readonly mode
true
```

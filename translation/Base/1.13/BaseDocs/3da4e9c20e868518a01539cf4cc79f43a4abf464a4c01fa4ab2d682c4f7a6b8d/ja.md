```julia
UndefVarError(var::Symbol, [scope])
```

現在のスコープでシンボルが定義されていません。

# Examples

```jldoctest
julia> a
ERROR: UndefVarError: `a` not defined in `Main`

julia> a = 1;

julia> a
1
```

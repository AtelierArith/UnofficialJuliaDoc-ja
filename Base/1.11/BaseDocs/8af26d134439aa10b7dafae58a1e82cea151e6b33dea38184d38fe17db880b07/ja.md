```
UndefVarError(var::Symbol, [scope])
```

現在のスコープにシンボルが定義されていません。

# 例

```jldoctest
julia> a
ERROR: UndefVarError: `a` not defined in `Main`

julia> a = 1;

julia> a
1
```

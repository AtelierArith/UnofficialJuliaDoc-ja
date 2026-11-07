```julia
Symbol(x...)::Symbol
```

引数の文字列表現を連結して、[`Symbol`](@ref)を作成します。

# Examples

```jldoctest
julia> Symbol("my", "name")
:myname

julia> Symbol("day", 4)
:day4
```

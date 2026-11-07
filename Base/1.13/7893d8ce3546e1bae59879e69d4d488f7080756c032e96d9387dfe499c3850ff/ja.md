```julia
valtype(type)
```

辞書型の値の型を取得します。[`eltype`](@ref)と同様に動作します。

# Examples

```jldoctest
julia> valtype(Dict(Int32(1) => "foo"))
String
```

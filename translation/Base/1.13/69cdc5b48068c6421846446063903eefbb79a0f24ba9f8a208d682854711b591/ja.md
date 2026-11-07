```julia
keytype(type)
```

辞書型のキーの型を取得します。[`eltype`](@ref)と同様に動作します。

# Examples

```jldoctest
julia> keytype(Dict(Int32(1) => "foo"))
Int32
```

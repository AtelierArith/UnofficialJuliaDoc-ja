```julia
keytype(type)
```

辞書型のキータイプを取得します。[`eltype`](@ref)と似た動作をします。

# 例

```jldoctest
julia> keytype(Dict(Int32(1) => "foo"))
Int32
```

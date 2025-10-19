```julia
isvalid(T, value) -> Bool
```

与えられた値がその型に対して有効であれば `true` を返します。現在、型は `AbstractChar` または `String` のいずれかです。`AbstractChar` の値は `AbstractChar` 型または [`UInt32`](@ref) 型であることができます。`String` の値はその型、`SubString{String}`、`Vector{UInt8}`、またはその連続した部分配列であることができます。

# 例

```jldoctest
julia> isvalid(Char, 0xd800)
false

julia> isvalid(String, SubString("thisisvalid",1,5))
true

julia> isvalid(Char, 0xd799)
true
```

!!! compat "Julia 1.6"
    部分配列の値のサポートは Julia 1.6 で追加されました。


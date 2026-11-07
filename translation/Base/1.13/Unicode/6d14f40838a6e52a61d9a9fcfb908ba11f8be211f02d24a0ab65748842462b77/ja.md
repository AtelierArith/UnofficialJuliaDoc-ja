```julia
isvalid(T, value)::Bool
```

指定された値がその型として有効な場合、`true`を返します。型は現在、`AbstractChar`または`String`のいずれかです。`AbstractChar`の値は、`AbstractChar`型または[`UInt32`](@ref)型にできます。`String`の値は、その型、`SubString{String}`、`Vector{UInt8}`、またはそれらの連続した部分配列にできます。

# Examples

```jldoctest
julia> isvalid(Char, 0xd800)
false

julia> isvalid(String, SubString("thisisvalid",1,5))
true

julia> isvalid(Char, 0xd799)
true
```

!!! compat "Julia 1.6"
    部分配列の値への対応はJulia 1.6で追加されました。


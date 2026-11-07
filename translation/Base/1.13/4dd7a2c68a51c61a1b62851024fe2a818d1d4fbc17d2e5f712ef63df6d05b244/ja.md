```julia
Base.isconcretedispatch(T)
```

`T` が、[dispatch tuple](@ref isdispatchtuple) の要素として現れ得る [concrete type](@ref isconcretetype) である場合に、true を返します。

関連項目: [`isdispatchtuple`](@ref)。

# Examples

```jldoctest
julia> Base.isconcretedispatch(Int)
true

julia> Base.isconcretedispatch(Number)
false

julia> Base.isconcretedispatch(DataType)
false

julia> Base.isconcretedispatch(Type{Int})
false
```

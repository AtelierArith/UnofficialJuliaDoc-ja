```julia
subtypes(T::DataType)
```

DataType `T` の即時サブタイプのリストを返します。現在ロードされているすべてのサブタイプが含まれており、現在のモジュールで表示されないものも含まれます。

参照: [`supertype`](@ref), [`supertypes`](@ref), [`methodswith`](@ref).

# 例

```jldoctest
julia> subtypes(Integer)
3-element Vector{Any}:
 Bool
 Signed
 Unsigned
```

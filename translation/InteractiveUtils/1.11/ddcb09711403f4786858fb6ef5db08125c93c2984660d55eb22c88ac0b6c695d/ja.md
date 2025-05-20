```
subtypes(T::DataType)
```

DataType `T` の即時サブタイプのリストを返します。現在ロードされているすべてのサブタイプが含まれており、現在のモジュールで表示されないものも含まれます。

関連情報として [`supertype`](@ref)、[`supertypes`](@ref)、[`methodswith`](@ref) も参照してください。

# 例

```jldoctest
julia> subtypes(Integer)
3-element Vector{Any}:
 Bool
 Signed
 Unsigned
```

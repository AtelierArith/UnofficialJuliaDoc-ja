```julia
subtypes(T::DataType)
```

DataType `T` の直接のサブタイプの一覧を返します。現在ロードされているサブタイプはすべて含まれ、現在のモジュールから見えないものも含まれます。

関連項目: [`supertype`](@ref)、[`supertypes`](@ref)、[`methodswith`](@ref)。

# Examples

```jldoctest
julia> subtypes(Integer)
3-element Vector{Any}:
 Bool
 Signed
 Unsigned
```

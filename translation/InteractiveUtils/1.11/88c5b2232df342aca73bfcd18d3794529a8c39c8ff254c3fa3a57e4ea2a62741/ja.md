```julia
subtypes(T::DataType)
```

DataType `T` の直接のサブタイプの一覧を返します。現在読み込まれているサブタイプはすべて含まれ、現在のモジュールから見えないものも含まれます。

[`supertype`](@ref)、[`supertypes`](@ref)、[`methodswith`](@ref) も参照してください。

# Examples

```jldoctest
julia> subtypes(Integer)
3-element Vector{Any}:
 Bool
 Signed
 Unsigned
```

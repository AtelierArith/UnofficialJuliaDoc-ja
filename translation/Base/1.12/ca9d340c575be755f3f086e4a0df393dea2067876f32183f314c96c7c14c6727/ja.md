```julia
supertype(T::Union{DataType, UnionAll})
```

型 `T` の直接のスーパタイプを返します。`T` は [`DataType`](@ref) または [`UnionAll`](@ref) 型であることができます。型 [`Union`](@ref) はサポートされていません。さらに、[Types](@ref man-types) に関する情報も参照してください。

# 例

```jldoctest
julia> supertype(Int32)
Signed

julia> supertype(Vector)
DenseVector (alias for DenseArray{T, 1} where T)
```

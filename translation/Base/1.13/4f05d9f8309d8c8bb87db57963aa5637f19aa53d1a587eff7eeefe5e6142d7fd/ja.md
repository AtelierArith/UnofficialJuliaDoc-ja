```julia
supertype(T::Union{DataType, UnionAll})
```

型 `T` の直接のスーパータイプを返します。`T` は、[`DataType`](@ref) 型または [`UnionAll`](@ref) 型です。型 [`Union`](@ref) はサポートしていません。[Types](@ref man-types) も参照してください。

# Examples

```jldoctest
julia> supertype(Int32)
Signed

julia> supertype(Vector)
DenseVector (alias for DenseArray{T, 1} where T)
```

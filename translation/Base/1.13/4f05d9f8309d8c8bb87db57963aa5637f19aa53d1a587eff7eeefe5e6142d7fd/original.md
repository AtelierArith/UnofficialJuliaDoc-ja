```julia
supertype(T::Union{DataType, UnionAll})
```

Return the direct supertype of type `T`. `T` can be a [`DataType`](@ref) or a [`UnionAll`](@ref) type. Does not support type [`Union`](@ref)s. Also see info on [Types](@ref man-types).

# Examples

```jldoctest
julia> supertype(Int32)
Signed

julia> supertype(Vector)
DenseVector (alias for DenseArray{T, 1} where T)
```

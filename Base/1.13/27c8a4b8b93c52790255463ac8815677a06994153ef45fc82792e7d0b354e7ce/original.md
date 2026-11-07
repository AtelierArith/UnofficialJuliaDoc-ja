```julia
insertdims(A; dims)
```

Inverse of [`dropdims`](@ref); return an array with new singleton dimensions at every dimension in `dims`.

Repeated dimensions are forbidden and the largest entry in `dims` must be less than or equal than `ndims(A) + length(dims)`.

The result shares the same underlying data as `A`, such that the result is mutable if and only if `A` is mutable, and setting elements of one alters the values of the other.

See also: [`dropdims`](@ref), [`reshape`](@ref), [`vec`](@ref).

# Examples

```jldoctest
julia> x = [1 2 3; 4 5 6]
2×3 Matrix{Int64}:
 1  2  3
 4  5  6

julia> insertdims(x, dims=3)
2×3×1 Array{Int64, 3}:
[:, :, 1] =
 1  2  3
 4  5  6

julia> insertdims(x, dims=(1,2,5)) == reshape(x, 1, 1, 2, 3, 1)
true

julia> dropdims(insertdims(x, dims=(1,2,5)), dims=(1,2,5))
2×3 Matrix{Int64}:
 1  2  3
 4  5  6
```

!!! compat "Julia 1.12"
    Requires Julia 1.12 or later.


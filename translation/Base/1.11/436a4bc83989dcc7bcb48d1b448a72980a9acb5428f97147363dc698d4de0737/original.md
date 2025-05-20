```
eachslice(A::AbstractArray; dims, drop=true)
```

Create a [`Slices`](@ref) object that is an array of slices over dimensions `dims` of `A`, returning views that select all the data from the other dimensions in `A`. `dims` can either be an integer or a tuple of integers.

If `drop = true` (the default), the outer `Slices` will drop the inner dimensions, and the ordering of the dimensions will match those in `dims`. If `drop = false`, then the `Slices` will have the same dimensionality as the underlying array, with inner dimensions having size 1.

See [`stack`](@ref)`(slices; dims)` for the inverse of `eachslice(A; dims::Integer)`.

See also [`eachrow`](@ref), [`eachcol`](@ref), [`mapslices`](@ref) and [`selectdim`](@ref).

!!! compat "Julia 1.1"
    This function requires at least Julia 1.1.


!!! compat "Julia 1.9"
    Prior to Julia 1.9, this returned an iterator, and only a single dimension `dims` was supported.


# Examples

```jldoctest
julia> m = [1 2 3; 4 5 6; 7 8 9]
3×3 Matrix{Int64}:
 1  2  3
 4  5  6
 7  8  9

julia> s = eachslice(m, dims=1)
3-element RowSlices{Matrix{Int64}, Tuple{Base.OneTo{Int64}}, SubArray{Int64, 1, Matrix{Int64}, Tuple{Int64, Base.Slice{Base.OneTo{Int64}}}, true}}:
 [1, 2, 3]
 [4, 5, 6]
 [7, 8, 9]

julia> s[1]
3-element view(::Matrix{Int64}, 1, :) with eltype Int64:
 1
 2
 3

julia> eachslice(m, dims=1, drop=false)
3×1 Slices{Matrix{Int64}, Tuple{Int64, Colon}, Tuple{Base.OneTo{Int64}, Base.OneTo{Int64}}, SubArray{Int64, 1, Matrix{Int64}, Tuple{Int64, Base.Slice{Base.OneTo{Int64}}}, true}, 2}:
 [1, 2, 3]
 [4, 5, 6]
 [7, 8, 9]
```

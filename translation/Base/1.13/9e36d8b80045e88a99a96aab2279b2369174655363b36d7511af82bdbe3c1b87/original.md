```julia
eachrow(A::AbstractVecOrMat) <: AbstractVector
```

Create a [`RowSlices`](@ref) object that is a vector of rows of matrix or vector `A`. Row slices are returned as `AbstractVector` views of `A`.

For the inverse, see [`stack`](@ref)`(rows; dims=1)`.

See also [`eachcol`](@ref), [`eachslice`](@ref) and [`mapslices`](@ref).

!!! compat "Julia 1.1"
    This function requires at least Julia 1.1.


!!! compat "Julia 1.9"
    Prior to Julia 1.9, this returned an iterator.


# Examples

```jldoctest
julia> a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> s = eachrow(a)
2-element RowSlices{Matrix{Int64}, Tuple{Base.OneTo{Int64}}, SubArray{Int64, 1, Matrix{Int64}, Tuple{Int64, Base.Slice{Base.OneTo{Int64}}}, true}}:
 [1, 2]
 [3, 4]

julia> s[1]
2-element view(::Matrix{Int64}, 1, :) with eltype Int64:
 1
 2
```

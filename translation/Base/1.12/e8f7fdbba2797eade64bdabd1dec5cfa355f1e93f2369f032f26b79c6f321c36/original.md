```julia
eachcol(A::AbstractVecOrMat) <: AbstractVector
```

Create a [`ColumnSlices`](@ref) object that is a vector of columns of matrix or vector `A`. Column slices are returned as `AbstractVector` views of `A`.

For the inverse, see [`stack`](@ref)`(cols)` or `reduce(`[`hcat`](@ref)`, cols)`.

See also [`eachrow`](@ref), [`eachslice`](@ref) and [`mapslices`](@ref).

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

julia> s = eachcol(a)
2-element ColumnSlices{Matrix{Int64}, Tuple{Base.OneTo{Int64}}, SubArray{Int64, 1, Matrix{Int64}, Tuple{Base.Slice{Base.OneTo{Int64}}, Int64}, true}}:
 [1, 3]
 [2, 4]

julia> s[1]
2-element view(::Matrix{Int64}, :, 1) with eltype Int64:
 1
 3
```

```julia
diagind(M::AbstractMatrix, k::Integer = 0, indstyle::IndexStyle = IndexLinear())
diagind(M::AbstractMatrix, indstyle::IndexStyle = IndexLinear())
```

An `AbstractRange` giving the indices of the `k`th diagonal of the matrix `M`. Optionally, an index style may be specified which determines the type of the range returned. If `indstyle isa IndexLinear` (default), this returns an `AbstractRange{Integer}`. On the other hand, if `indstyle isa IndexCartesian`, this returns an `AbstractRange{CartesianIndex{2}}`.

If `k` is not provided, it is assumed to be `0` (corresponding to the main diagonal).

See also: [`diag`](@ref), [`diagm`](@ref), [`Diagonal`](@ref).

# Examples

```jldoctest
julia> A = [1 2 3; 4 5 6; 7 8 9]
3×3 Matrix{Int64}:
 1  2  3
 4  5  6
 7  8  9

julia> diagind(A, -1)
2:4:6

julia> diagind(A, IndexCartesian())
StepRangeLen(CartesianIndex(1, 1), CartesianIndex(1, 1), 3)
```

!!! compat "Julia 1.11"
    Specifying an `IndexStyle` requires at least Julia 1.11.


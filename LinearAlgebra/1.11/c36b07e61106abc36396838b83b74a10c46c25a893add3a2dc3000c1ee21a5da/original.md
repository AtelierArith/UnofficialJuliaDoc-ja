```
diag(M, k::Integer=0)
```

The `k`th diagonal of a matrix, as a vector.

See also [`diagm`](@ref), [`diagind`](@ref), [`Diagonal`](@ref), [`isdiag`](@ref).

# Examples

```jldoctest
julia> A = [1 2 3; 4 5 6; 7 8 9]
3×3 Matrix{Int64}:
 1  2  3
 4  5  6
 7  8  9

julia> diag(A,1)
2-element Vector{Int64}:
 2
 6
```

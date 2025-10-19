```julia
diagview(M, k::Integer=0)
```

Return a view into the `k`th diagonal of the matrix `M`.

See also [`diag`](@ref), [`diagind`](@ref).

!!! compat "Julia 1.12"
    This function requires Julia 1.12 or later.


# Examples

```jldoctest
julia> A = [1 2 3; 4 5 6; 7 8 9]
3×3 Matrix{Int64}:
 1  2  3
 4  5  6
 7  8  9

julia> diagview(A)
3-element view(::Vector{Int64}, 1:4:9) with eltype Int64:
 1
 5
 9

julia> diagview(A, 1)
2-element view(::Vector{Int64}, 4:4:8) with eltype Int64:
 2
 6
```

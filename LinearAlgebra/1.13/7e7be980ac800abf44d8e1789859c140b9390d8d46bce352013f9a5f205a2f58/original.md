```julia
LinearAlgebra.uplo(S::Union{Symmetric, Hermitian})::Symbol
```

Return a `Symbol` corresponding to the stored triangular half (`:U` or `:L`) in the matrix `S`, that is, the elements are common between `S` and `parent(S)` for that triangular half.

# Example

```jldoctest
julia> S = Symmetric([1 2; 3 4], :U)
2×2 Symmetric{Int64, Matrix{Int64}}:
 1  2
 2  4

julia> LinearAlgebra.uplo(S)
:U

julia> H = Hermitian([1 2; 3 4], :L)
2×2 Hermitian{Int64, Matrix{Int64}}:
 1  3
 3  4

julia> LinearAlgebra.uplo(H)
:L
```

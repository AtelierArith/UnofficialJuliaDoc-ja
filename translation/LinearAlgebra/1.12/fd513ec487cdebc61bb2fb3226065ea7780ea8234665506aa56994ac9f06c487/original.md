```julia
isposdef(A) -> Bool
```

Test whether a matrix is positive definite (and Hermitian) by trying to perform a Cholesky factorization of `A`.

See also [`isposdef!`](@ref), [`cholesky`](@ref).

# Examples

```jldoctest
julia> A = [1 2; 2 50]
2×2 Matrix{Int64}:
 1   2
 2  50

julia> isposdef(A)
true
```

```julia
cholesky!(A::AbstractMatrix, RowMaximum(); tol = 0.0, check = true) -> CholeskyPivoted
```

The same as [`cholesky`](@ref), but saves space by overwriting the input `A`, instead of creating a copy. An [`InexactError`](@ref) exception is thrown if the factorization produces a number not representable by the element type of `A`, e.g. for integer types.

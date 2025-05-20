```
cholesky!(A::AbstractMatrix, NoPivot(); check = true) -> Cholesky
```

The same as [`cholesky`](@ref), but saves space by overwriting the input `A`, instead of creating a copy. An [`InexactError`](@ref) exception is thrown if the factorization produces a number not representable by the element type of `A`, e.g. for integer types.

# Examples

```jldoctest
julia> A = [1 2; 2 50]
2×2 Matrix{Int64}:
 1   2
 2  50

julia> cholesky!(A)
ERROR: InexactError: Int64(6.782329983125268)
Stacktrace:
[...]
```

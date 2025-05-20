```
rdiv!(A, B)
```

Compute `A / B` in-place and overwriting `A` to store the result.

The argument `B` should *not* be a matrix.  Rather, instead of matrices it should be a factorization object (e.g. produced by [`factorize`](@ref) or [`cholesky`](@ref)). The reason for this is that factorization itself is both expensive and typically allocates memory (although it can also be done in-place via, e.g., [`lu!`](@ref)), and performance-critical situations requiring `rdiv!` usually also require fine-grained control over the factorization of `B`.

!!! note
    Certain structured matrix types, such as `Diagonal` and `UpperTriangular`, are permitted, as these are already in a factorized form


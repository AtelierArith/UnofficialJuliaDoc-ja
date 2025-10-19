```julia
ldiv!(Y, A, B) -> Y
```

Compute `A \ B` in-place and store the result in `Y`, returning the result.

The argument `A` should *not* be a matrix.  Rather, instead of matrices it should be a factorization object (e.g. produced by [`factorize`](@ref) or [`cholesky`](@ref)). The reason for this is that factorization itself is both expensive and typically allocates memory (although it can also be done in-place via, e.g., [`lu!`](@ref)), and performance-critical situations requiring `ldiv!` usually also require fine-grained control over the factorization of `A`.

!!! note
    Certain structured matrix types, such as `Diagonal` and `UpperTriangular`, are permitted, as these are already in a factorized form


# Examples

```jldoctest
julia> A = [1 2.2 4; 3.1 0.2 3; 4 1 2];

julia> B = [1, 2.5, 3];

julia> Y = similar(B); # use similar since there is no need to read from it

julia> ldiv!(Y, qr(A), B); # you may also try qr!(A) to further reduce allocation

julia> Y ≈ A \ B
true
```

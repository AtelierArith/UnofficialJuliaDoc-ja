```
copytrito!(B, A, uplo) -> B
```

Copies a triangular part of a matrix `A` to another matrix `B`. `uplo` specifies the part of the matrix `A` to be copied to `B`. Set `uplo = 'L'` for the lower triangular part or `uplo = 'U'` for the upper triangular part.

!!! compat "Julia 1.11"
    `copytrito!` requires at least Julia 1.11.


# Examples

```jldoctest
julia> A = [1 2 ; 3 4];

julia> B = [0 0 ; 0 0];

julia> copytrito!(B, A, 'L')
2×2 Matrix{Int64}:
 1  0
 3  4
```

```julia
lacpy!(B, A, uplo) -> B
```

Copies all or part of a matrix `A` to another matrix `B`. uplo specifies the part of the matrix `A` to be copied to `B`. Set `uplo = 'L'` for the lower triangular part, `uplo = 'U'` for the upper triangular part, any other character for all the matrix `A`.

# Examples

```jldoctest
julia> A = [1. 2. ; 3. 4.];

julia> B = [0. 0. ; 0. 0.];

julia> LAPACK.lacpy!(B, A, 'U')
2×2 Matrix{Float64}:
 1.0  2.0
 0.0  4.0
```

```julia
hpmv!(uplo, α, AP, x, β, y)
```

Update vector `y` as `α*A*x + β*y`, where `A` is a Hermitian matrix provided in packed format `AP`.

With `uplo = 'U'`, the array AP must contain the upper triangular part of the Hermitian matrix packed sequentially, column by column, so that `AP[1]` contains `A[1, 1]`, `AP[2]` and `AP[3]` contain `A[1, 2]` and `A[2, 2]` respectively, and so on.

With `uplo = 'L'`, the array AP must contain the lower triangular part of the Hermitian matrix packed sequentially, column by column, so that `AP[1]` contains `A[1, 1]`, `AP[2]` and `AP[3]` contain `A[2, 1]` and `A[3, 1]` respectively, and so on.

The scalar inputs `α` and `β` must be complex or real numbers.

The array inputs `x`, `y` and `AP` must all be of `ComplexF32` or `ComplexF64` type.

Return the updated `y`.

!!! compat "Julia 1.5"
    `hpmv!` requires at least Julia 1.5.


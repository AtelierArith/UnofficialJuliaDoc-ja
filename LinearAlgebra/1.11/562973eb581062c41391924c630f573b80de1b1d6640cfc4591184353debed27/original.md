```
hermitian(A, uplo::Symbol=:U)
```

Construct a hermitian view of `A`. If `A` is a matrix, `uplo` controls whether the upper (if `uplo = :U`) or lower (if `uplo = :L`) triangle of `A` is used to implicitly fill the other one. If `A` is a `Number`, its real part is returned converted back to the input type.

If a hermitian view of a matrix is to be constructed of which the elements are neither matrices nor numbers, an appropriate method of `hermitian` has to be implemented. In that case, `hermitian_type` has to be implemented, too.

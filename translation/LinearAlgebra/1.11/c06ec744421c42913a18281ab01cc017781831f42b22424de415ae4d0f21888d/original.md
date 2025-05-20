```
symmetric(A, uplo::Symbol=:U)
```

Construct a symmetric view of `A`. If `A` is a matrix, `uplo` controls whether the upper (if `uplo = :U`) or lower (if `uplo = :L`) triangle of `A` is used to implicitly fill the other one. If `A` is a `Number`, it is returned as is.

If a symmetric view of a matrix is to be constructed of which the elements are neither matrices nor numbers, an appropriate method of `symmetric` has to be implemented. In that case, `symmetric_type` has to be implemented, too.

```
trmv(ul, tA, dA, A, b)
```

Return `op(A)*b`, where `op` is determined by [`tA`](@ref stdlib-blas-trans). Only the [`ul`](@ref stdlib-blas-uplo) triangle of `A` is used. [`dA`](@ref stdlib-blas-diag) determines if the diagonal values are read or are assumed to be all ones.

```
trmm(side, ul, tA, dA, alpha, A, B)
```

Return `alpha*A*B` or one of the other three variants determined by [`side`](@ref stdlib-blas-side) and [`tA`](@ref stdlib-blas-trans). Only the [`ul`](@ref stdlib-blas-uplo) triangle of `A` is used. [`dA`](@ref stdlib-blas-diag) determines if the diagonal values are read or are assumed to be all ones.

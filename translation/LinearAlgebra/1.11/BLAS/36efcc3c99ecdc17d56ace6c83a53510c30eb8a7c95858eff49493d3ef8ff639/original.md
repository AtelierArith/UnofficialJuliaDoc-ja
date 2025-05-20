```
trsv(ul, tA, dA, A, b)
```

Return the solution to `A*x = b` or one of the other two variants determined by [`tA`](@ref stdlib-blas-trans) and [`ul`](@ref stdlib-blas-uplo). [`dA`](@ref stdlib-blas-diag) determines if the diagonal values are read or are assumed to be all ones.

```
nrm2(n, X, incx)
```

2-norm of a vector consisting of `n` elements of array `X` with stride `incx`.

# Examples

```jldoctest
julia> BLAS.nrm2(4, fill(1.0, 8), 2)
2.0

julia> BLAS.nrm2(1, fill(1.0, 8), 2)
1.0
```

```julia
nrm2(n, X, incx)
```

ストライドが `incx` の配列 `X` の要素 `n` 個からなるベクトルの 2 ノルム。

# Examples

```jldoctest
julia> BLAS.nrm2(4, fill(1.0, 8), 2)
2.0

julia> BLAS.nrm2(1, fill(1.0, 8), 2)
1.0
```

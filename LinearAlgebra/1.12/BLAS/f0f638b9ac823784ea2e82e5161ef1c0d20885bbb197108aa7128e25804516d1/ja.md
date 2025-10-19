```julia
nrm2(n, X, incx)
```

配列 `X` の `n` 要素からなるベクトルの 2-ノルムで、ストライドは `incx` です。

# 例

```jldoctest
julia> BLAS.nrm2(4, fill(1.0, 8), 2)
2.0

julia> BLAS.nrm2(1, fill(1.0, 8), 2)
1.0
```

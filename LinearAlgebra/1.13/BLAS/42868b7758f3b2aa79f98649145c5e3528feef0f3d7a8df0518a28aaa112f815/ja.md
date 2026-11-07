```julia
dotu(n, X, incx, Y, incy)
```

ストライドが `incx` の配列 `X` の要素 `n` 個と、ストライドが `incy` の配列 `Y` の要素 `n` 個からなる、2つの複素ベクトルの内積。

# Examples

```jldoctest
julia> BLAS.dotu(10, fill(1.0im, 10), 1, fill(1.0+im, 20), 2)
-10.0 + 10.0im
```

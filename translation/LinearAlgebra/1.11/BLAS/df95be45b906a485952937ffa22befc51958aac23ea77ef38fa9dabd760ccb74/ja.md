```
dotu(n, X, incx, Y, incy)
```

複素ベクトルの2つのドット関数で、配列 `X` の `n` 要素とストライド `incx`、配列 `Y` の `n` 要素とストライド `incy` から構成されています。

# 例

```jldoctest
julia> BLAS.dotu(10, fill(1.0im, 10), 1, fill(1.0+im, 20), 2)
-10.0 + 10.0im
```

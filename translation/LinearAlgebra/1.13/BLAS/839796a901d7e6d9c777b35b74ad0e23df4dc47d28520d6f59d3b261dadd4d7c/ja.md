```julia
dotc(n, X, incx, U, incy)
```

2つの複素ベクトルの内積を計算します。1つ目のベクトルは、配列 `X` の `n` 個の要素をストライド `incx` で取り出したもの、2つ目のベクトルは、配列 `U` の `n` 個の要素をストライド `incy` で取り出したものです。1つ目のベクトルは複素共役を取ります。

# Examples

```jldoctest
julia> BLAS.dotc(10, fill(1.0im, 10), 1, fill(1.0+im, 20), 2)
10.0 - 10.0im
```

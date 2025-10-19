```julia
dotc(n, X, incx, U, incy)
```

2つの複素ベクトルのためのドット関数で、ストライド `incx` を持つ配列 `X` の `n` 要素と、ストライド `incy` を持つ配列 `U` の `n` 要素から成り、最初のベクトルを共役します。

# 例

```jldoctest
julia> BLAS.dotc(10, fill(1.0im, 10), 1, fill(1.0+im, 20), 2)
10.0 - 10.0im
```

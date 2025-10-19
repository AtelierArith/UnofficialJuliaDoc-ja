```julia
asum(n, X, incx)
```

配列 `X` の最初の `n` 要素の大きさの合計で、ストライドは `incx` です。

実数配列の場合、大きさは絶対値です。複素数配列の場合、大きさは実部の絶対値と虚部の絶対値の合計です。

# 例

```jldoctest
julia> BLAS.asum(5, fill(1.0im, 10), 2)
5.0

julia> BLAS.asum(2, fill(1.0im, 10), 5)
2.0
```
